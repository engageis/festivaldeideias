# coding: utf-8

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # User has many types of services (facebook, twitter and so on)
  has_many :services
  has_many :ideas
  has_many :collaborators
  has_many :collaborated_ideas, through: :collaborators, source: :idea
  validates_presence_of :name, :email
  attr_accessible :name, :email, :email_notifications, :telephone

  before_create :updates_notifications_read_at

  reverse_geocoded_by :latitude, :longitude do |user, results|
    if geo = results.first
      user.city = geo.city
      user.state = geo.state
      user.country = geo.country
    end
  end
  def check_before_reverse_geocode
    reverse_geocode if self.latitude and self.longitude
  end
  after_validation :check_before_reverse_geocode

  # This affects links
  def to_param
    "#{id}-#{name.parameterize}"
  end

  def updates_notifications_read_at
    self.notifications_read_at = Time.now
  end

  def self.create_from_hash!(hash)
    self.create(:name => hash['info']['name'], :email => hash['info']['email'])
  end
  
  def avatar
    self.services.first.facebook_avatar
  rescue
  end

  def profile
    self.services.first.facebook_profile
  rescue
  end

  def new_notifications_count
    Audit.notifications(self).where(["created_at > ?", self.notifications_read_at]).delete_if{ |audit| audit.notification_text(self).nil? }.size
  end
  
  def notifications
    Audit.notifications(self).all.delete_if { |audit| audit.notification_text(self).nil? }
  end

end
