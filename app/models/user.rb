# coding: utf-8
class User < ActiveRecord::Base

  include Rails.application.routes.url_helpers


  # User has many types of services (facebook, twitter and so on)
  has_many :services
  has_many :ideas
  validates_presence_of :name, :email
  attr_accessible :name, :email

  def self.create_from_hash!(hash)
    self.create(:name => hash['user_info']['name'], :email => hash['user_info']['email'])
  end

  def notifications
    Idea.new_collaborations(self).map do |i|
      "<a href='#{category_idea_path(i.parent.category, i.parent.id)}'>#{i.user.name} quer colaborar com a sua ideia \"#{i.parent.title}\"</a>\""
    end +
    Idea.collaborations_status_changed(self).map do |i|
      "<a href='#{category_idea_path(i.parent.category, i.parent.id)}'>A sua colaboração para a ideia \"#{i.parent.title}\" foi #{i.accepted ? "aceita" : "rejeitada"}.</a>"
    end +
    Idea.collaborated_idea_changed(self).map do |i|
      "<a href='#{category_idea_path(i.category, i.id)}'>A ideia \"#{i.title}\" a qual você colaborou foi atualizada.</a>"
    end
  end
end

