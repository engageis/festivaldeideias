class Service < ActiveRecord::Base
  # A service belongs to an User, which can have multiple services.
  belongs_to :user
  validates_presence_of :uid, :provider, :user
  attr_accessible :provider, :uid, :user, :profile


  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Service.create(:user => user, :uid => hash['uid'], :provider => hash['provider'], :profile => hash['extra']['user_hash']['id'])
  end


  def facebook_avatar
    "http://graph.facebook.com/#{profile}/picture?type=square"
  end
end
