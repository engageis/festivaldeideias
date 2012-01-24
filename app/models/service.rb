class Service < ActiveRecord::Base
  # A service belongs to an User, which can have multiple services.
  belongs_to :user
  validates_presence_of :uid, :provider, :user
  attr_accessible :provider, :uid, :user


  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash!(hash)
    Service.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
  end


  def facebook_avatar
    "http://graph.facebook.com/#{uid}/picture?type=square"
  end

  def facebook_profile
    "https://www.facebook.com/profile.php?id=#{uid}"
  end
end
