class User < ActiveRecord::Base
  
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  validates_presence_of :provider, :uid, :site
  validates_uniqueness_of :uid, :scope => :provider
  validates_length_of :bio, :maximum => 140
  validates :email, :email => true, :allow_nil => true, :allow_blank => true
  has_many :comments
  has_many :ideas
  has_many :secondary_users, :class_name => 'User', :foreign_key => :primary_user_id
  belongs_to :site
  has_and_belongs_to_many :sites
  belongs_to :primary, :class_name => 'User', :foreign_key => :primary_user_id

  scope :primary, :conditions => ["primary_user_id IS NULL"]

  mount_uploader :image, UserImageUploader

  def to_param
    return "#{self.id}" unless self.display_name
    "#{self.id}-#{self.display_name.parameterize}"
  end

  def self.find_with_omni_auth(provider, uid)
    u = User.find_by_provider_and_uid(provider, uid)
    return nil unless u
    u.primary.nil? ? u : u.primary
  end

  def self.create_with_omniauth(site, auth, primary_user_id = nil)
    u = create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.name = auth["user_info"][:name] if user.name.nil?
      user.email = auth["user_info"]["email"]
      user.email = auth["extra"]["user_hash"]["email"] if auth["extra"] and auth["extra"]["user_hash"] and user.email.nil?
      user.nickname = auth["user_info"]["nickname"]
      user.bio = auth["user_info"]["description"][0..139] if auth["user_info"]["description"]
      user.image_url = auth["user_info"]["image"]
      user.site = site
      user.locale = I18n.locale.to_s
    end
    if u.primary.nil? and primary_user_id
      u.primary = User.find_by_id(primary_user_id)
    end
    u.primary.nil? ? u : u.primary
  end
  
  def display_name
    name || nickname || I18n.t('user.no_name')
  end
  
  def display_image
    (image and image.thumb.url) || gravatar_url || image_url || '/images/user.png'
  end
  
  def display_bio
    bio and bio.gsub("\n", "<br/>")
  end
  
  def remember_me_hash
    Digest::MD5.new.update("#{self.provider}###{self.uid}").to_s
  end
  
  def as_json(options={})
    {
      :id => id,
      :email => email,
      :name => display_name,
      :bio => display_bio,
      :image => display_image
    }
  end
  
  protected

  # Returns a Gravatar URL associated with the email parameter
  def gravatar_url
    return unless email
    "http://gravatar.com/avatar/#{Digest::MD5.new.update(email)}.jpg?default=#{image_url or "http://catarse.me/images/user.png"}"
  end

end
