# coding: utf-8
module UserNotification 
  class Notify
    attr_accessor :link, :date
  end
end

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include UserNotification

  # User has many types of services (facebook, twitter and so on)
  has_many :services
  has_many :ideas
  has_many :collaborations, class_name: "Idea", conditions: "accepted AND parent_id IS NOT NULL"
  validates_presence_of :name, :email
  attr_accessible :name, :email

  before_create :updates_notifications_read_at

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
    Idea.new_collaborations(self).where(["created_at > ?", self.notifications_read_at]).size + 
    Idea.collaborations_status_changed(self).where(["updated_at > ?", self.notifications_read_at]).size + 
    Idea.collaborated_idea_changed(self).where(["updated_at > ?", self.notifications_read_at]).size
  end
  
  def notifications
    self.all_notifications.sort { |a,b| b.date <=> a.date }
  end

  protected 
  def all_notifications
    Idea.collaborations_status_changed(self).map do |i|
      s = Notify.new 
      if i.accepted
        s.link = I18n.t(
          "notifications.colaboration_accepted_html", 
          link: category_idea_path(i.parent.category, i.parent.to_param), parent: i.parent.title,
          class: self.notifications_read_at < i.updated_at ? 'new' : 'old')
      else
        s.link = I18n.t(
          "notifications.colaboration_refused_html", 
          link: ramify_idea_path(i), parent: i.parent.title,
          class: self.notifications_read_at < i.updated_at ? 'new' : 'old'
        ) 
      end
        s.date = i.updated_at
        s
    end +
    Idea.new_collaborations(self).map do |i|
      s = Notify.new
      s.link = I18n.t(
        "notifications.new_colaboration_html", 
        link: category_idea_path(i.parent.category, i.parent.to_param), name: i.user.name, parent: i.parent.title,
        class: self.notifications_read_at < i.updated_at ? 'new' : 'old'
      )
      s.date = i.updated_at
      s
    end +
    Idea.collaborated_idea_changed(self).map do |i|
      s = Notify.new
      s.link = I18n.t(
        "notifications.updated_idea_html", 
        link: category_idea_path(i.category, i.to_param), parent: i.title,
        class: self.notifications_read_at < i.updated_at ? 'new' : 'old'
      )
      s.date = i.updated_at
      s
    end
  end
end

