class Idea < ActiveRecord::Base

  # Logs all changes on this model; who made it, what kind and associated models.
  # See https://github.com/collectiveidea/audited
  # By default, whenever an idea is created, updated or destroyed, a new audit is created.
  audited

  geocoded_by :ip_for_geocoding do |idea, results|
    if geo = results.first
      idea.latitude = geo.latitude
      idea.longitude = geo.longitude
      idea.city = geo.city
      idea.state = geo.state
      idea.country = geo.country
    end
  end
  after_validation :geocode

  require 'json'
  require 'open-uri'

  include AutoHtml
  include Rails.application.routes.url_helpers
  include PgSearch

  belongs_to :user
  belongs_to :category, class_name: "IdeaCategory", foreign_key: :category_id
  has_many :messages
  has_many :collaborators, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  validates_presence_of :title, :description, :category_id, :user_id, :minimum_investment

  scope :featured, where(featured: true).order('position DESC')
  scope :latest, order('updated_at DESC')
  scope :recent, order('created_at DESC')
  scope :popular, order('likes DESC')

  pg_search_scope :match_and_find, against: [:title, :description, :city],
                  associated_against: {user: :name},
                  ignoring: :accents

  # Callbacks
  after_create :set_facebook_url

  attr_accessible :user_id, :title, :headline, :description, :featured, :recommend, :likes, :position, :category_id, :minimum_investment, :tokbox_session, :comment_count

  def cocreation_channel
    "cocreation-#{self.id}"
  end

  # Display geolocation data methods
  def display_latitude
    self.user.latitude or self.latitude
  end

  def display_longitude
    self.user.longitude or self.longitude
  end

  def display_city
    self.user.city or self.city
  end

  def display_state
    self.user.state or self.state
  end

  def display_country
    self.user.country or self.country
  end

  # Modify the json response
  def as_json(options={})
    {
      id: id,
      title: title,
      headline: headline,
      category: category,
      user: user.id,
      description: description,
      description_html: description_html,
      likes: likes,
      collaborators: self.collaborators.count,
      minimum_investment: minimum_investment,
      formatted_minimum_investment: formatted_minimum_investment,
      url: category_idea_path(category, self),
      latitude: display_latitude,
      longitude: display_longitude,
      city: display_city,
      state: display_state,
      country: display_country
    }
  end

  def external_url
    "http://festivaldeideias.org.br/ideas/#{self.id}"
  end

  # This affects links
  def to_param
    "#{id}-#{title.parameterize}"
  end

  # Convert the description text
  def description_html
    convert_html description
  end

  def formatted_minimum_investment
    ActionController::Base.helpers.number_to_currency(self.minimum_investment)
  end

  def check_minimum_investment
    self.minimum_investment = minimum_investment_before_type_cast.tr('R$.', '')
  end

  def convert_html(text)
    auto_html text do
      image
      youtube :width => 510, :height => 332
      vimeo :width => 510, :height => 332
      link :target => :_blank
      redcarpet :target => :_blank
    end
  end

  # Hook to update likes count when someone visits the #show page
  # of an idea
  
  def get_facebook_data(url)
    JSON.parse(open(url).read)
  end
  
  def update_facebook_likes
    facebook_query_url = 'https://api.facebook.com/method/fql.query?format=json&query=' 
    fql = "SELECT total_count, commentsbox_count FROM link_stat WHERE url='%s'"
    path = self.external_url
    facebook_data = self.get_facebook_data(facebook_query_url + URI.encode(fql % path))
    total_count = facebook_data.first["total_count"]
    comment_count = facebook_data.first["commentsbox_count"]
    self.update_attribute(:likes, total_count.to_i) if total_count
    self.update_attribute(:comment_count, comment_count.to_i) if comment_count
  end

  def set_facebook_url
    url = category_idea_url(self.category, self, host: "festivaldeideias.org.br")
    self.update_attribute(:facebook_url, url)
  end

  def set_tokbox_settings
    session = TOKBOX.create_session(self.external_url)
    self.update_attribute(:tokbox_session, session.session_id)
  end
  
  def after_audit
    Audit.pending.where(auditable_id: self.id).each do |pending_audit|
      pending_audit.set_timeline_and_notifications_data!
      pending_audit.users_to_notify.each do |user_to_notify|
        if user_to_notify.email_notifications and pending_audit.notification_text(user_to_notify)
          IdeaMailer.notification_email(pending_audit, user_to_notify).deliver
        end
      end
    end
  end
  
  def ip_for_geocoding
    audit = Audit.where(auditable_id: self.id).where("remote_address IS NOT NULL").order(:created_at).first
    audit.remote_address if audit
  end

  def similar_ideas
    Idea.where("id <> #{self.id}").order("similarity((title || ' ' || description), (SELECT title || ' ' || description FROM ideas WHERE id = #{self.id})) DESC").limit(3)
  end
  
end
