class Idea < ActiveRecord::Base
  require 'json'
  require 'open-uri'

  include AutoHtml
  include ActiveRecord::SpawnMethods
  include Rails.application.routes.url_helpers


  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :category_id
  belongs_to :parent  , :class_name => "Idea", :foreign_key => :parent_id

  has_many :colaborations, :class_name => "Idea", :foreign_key => :parent_id

  validates_presence_of :title, :description, :category_id, :user_id

  # Scope for colaborations
  scope :not_accepted, where(:accepted => nil).order('created_at DESC')

  scope :featured,  where(:featured => true, :parent_id => nil).order('position DESC')
  scope :latest,    where(:parent_id => nil).order('updated_at DESC')
  scope :recent,    where(:parent_id => nil).order('created_at DESC')
  scope :popular,   select("DISTINCT ON (ideas.id) ideas.*").
                    joins("INNER JOIN ideas b ON b.parent_id = ideas.id")

  scope :new_collaborations, ->(user) { where(['parent_id IN (?)', user.ideas.map(&:id)]).order("created_at DESC") }

  scope :collaborations_status_changed, ->(user) { 
    where(['user_id = ? AND accepted IS NOT NULL AND parent_id IS NOT NULL', user.id]).order("updated_at DESC")
  }

  scope :collaborated_idea_changed, ->(user) {
    where(['EXISTS(
              SELECT true FROM ideas AS collaboration
              WHERE collaboration.parent_id = ideas.id
              AND collaboration.user_id = ?
          )', user.id]).order("updated_at DESC")
  }

  def self.ramify!(idea)
    idea.update_attributes! parent_id: nil, accepted: nil
  end

  def rejected_colaborations
    self.colaborations.where(accepted: false)
  end

  def accepted_colaborations
    self.colaborations.where(accepted: true)
  end

  def self.create_colaboration(params = {})
    if params.has_key? :parent_id
      Idea.create(params)
      idea = Idea.where(parent_id: params[:parent_id])
      # IdeaMailer.new_colaboration_notification(idea)
    end
  end

  # Modify the json response
  def as_json(options={})
    {
      :id => id,
      :title => title,
      :headline => headline,
      :category => category,
      :user => user.id,
      :description => description,
      :description_html => description_html,
      :likes => likes,
      :colaborations => colaborations.count,
      :minimum_investment => minimum_investment,
      :formatted_minimum_investment => formatted_minimum_investment,
      :url => category_idea_path(category, self)
    }
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
    ActionController::Base.helpers.number_to_currency(minimum_investment)
  end


  # Use AutoHtml gem to convert texts
  def convert_html(text)
    auto_html text do
      html_escape :map => {
        '&' => '&amp;',
        '>' => '&gt;',
        '<' => '&lt;',
        '"' => '"'
      }
      image
      youtube :width => 510, :height => 332
      vimeo :width => 510, :height => 332
      link :target => :_blank
      redcarpet :target => :_blank
    end
  end

  # Atualiza o número de likes da ideia
  def update_facebook_likes
    default_url_options[:host] = 'festivaldeideias.org.br'
    facebook_query_url = 'https://api.facebook.com/method/fql.query?format=json&query=' 
    fql = "SELECT total_count FROM link_stat WHERE url='%s'"
    #path = "http://festivaldeideias.org.br" + idea_path(self)
    path = category_idea_url(self.category, self)
    total_count = JSON.parse(open(facebook_query_url + URI.encode(fql % path)).read).first["total_count"]
    self.update_attribute(:likes, total_count.to_i) if total_count
  end

  # Remove R$ e pontuação do investimento mínimo. Tem o unmaskMoney,
  # mas depende do Javascript e não sei se confio só nisso.
  def minimum_investment=(text)
    case text
    when Float, Integer
      super(text.to_f)
    else
      number = text.to_s.gsub(/\D+/, '')
      # Se por algum motivo o texto vier curto demais
      while number.length < 3
        number = "0" + number
      end
      # NOTE: SEMPRE será inserido um ponto separador de decimais
      super(number[0..-3] + '.' + number[-2..-1])
    end
  end
end
