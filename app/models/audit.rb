# coding: utf-8

class Audit < ActiveRecord::Base

  belongs_to :user
  belongs_to :idea, foreign_key: :auditable_id
  belongs_to :actual_user, class_name: "User", foreign_key: :actual_user_id
  serialize :audited_changes
  serialize :notification_texts
  
  scope :recent, where("timeline_type IS NOT NULL AND timeline_type <> 'ignore'").order("created_at DESC").limit(100)
  scope :pending, where("timeline_type IS NULL")

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  def self.notifications(user_to_notify)
    where("auditable_id IN (SELECT id FROM ideas WHERE user_id = #{user_to_notify.id}) OR auditable_id IN (SELECT idea_id FROM collaborators WHERE user_id = #{user_to_notify.id})").order("created_at DESC")
  end

  def users_to_notify
    return unless self.idea
    users = [self.idea.user] + self.idea.collaborators.map(&:user)
    users.uniq
  end

  def notification_text(user_to_notify)
    return unless self.timeline_type and self.idea and self.notification_texts
    return if self.timeline_type == "collaboration_created" and self.actual_user == user_to_notify
    if self.idea.user == user_to_notify
      self.notification_texts[:creator]
    else
      self.notification_texts[:collaborators]
    end
  end
  
  def notification_subject
    return unless self.idea and self.timeline_type
    case timeline_type
    when "idea_created"
      "Tem ideia nova no FdI"
    when "edited_by_creator"
      "Tem novidades na ideia #{self.idea.title}"
    when "likes_updated"
      "Tem gente curtindo a ideia #{self.idea.title}"
    when "comments_updated"
      "Novos comentários na ideia #{self.idea.title}"
    when "collaboration_created"
      "Colaboração enviada para a ideia #{self.idea.title}"
    end
  end

  # IMPORTANT NOTICE for developers: this method is called by migration StoreAuditsTimelineData.
  # If you remove it or change its behaviour, please edit the migration as well
  def set_timeline_and_notifications_data!
    self.timeline_type = generated_timeline_type
    self.actual_user_id = generated_actual_user_id
    self.text, self.notification_texts = generated_texts
    self.save
  end
  
  def generated_timeline_type
    return "ignore" unless self.idea
    return "idea_created" if idea_created?
    return "edited_by_creator" if edited_by_creator?
    return "likes_updated" if likes_updated?
    return "comments_updated" if comments_updated?
    return "collaboration_created" if collaboration_created?
    "ignore"
  end
  
  def generated_actual_user_id
    return unless self.idea
    return self.idea.user_id if self.idea and ["likes_updated", "comments_updated"].include?(self.timeline_type)
    return self.idea.collaborations.last.user_id if self.timeline_type == "collaboration_created"
    self.user_id or self.idea.user_id
  end
  
  def generated_texts

    return [nil, nil] unless self.idea

    if idea_created?
      timeline_text = I18n.t("audit.create", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea))
      notification_texts = nil
      return [timeline_text, notification_texts]
    end
    
    if edited_by_creator?
      timeline_text = I18n.t("audit.edit", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea))
      notification_texts = {
        collaborators: I18n.t("audit.notification.edit.collaborators", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea))
      }
      return [timeline_text, notification_texts]
    end
    
    if likes_updated?
      timeline_text = I18n.t("audit.likes", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), likes: pluralize(self.audited_changes["likes"].last, "pessoa"))
      notification_texts = {
        creator: I18n.t("audit.notification.likes.creator", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), likes: pluralize(self.audited_changes["likes"].last, "pessoa")),
        collaborators: I18n.t("audit.notification.likes.collaborators", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), likes: pluralize(self.audited_changes["likes"].last, "pessoa"))
      }
      return [timeline_text, notification_texts]
    end

    if comments_updated?
      timeline_text = I18n.t("audit.comments", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), comments: pluralize(self.audited_changes["comment_count"].last, "comentário"))
      notification_texts = {
        creator: I18n.t("audit.notification.comments.creator", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), comments: pluralize(self.audited_changes["comment_count"].last, "comentário")),
        collaborators: I18n.t("audit.notification.comments.collaborators", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), comments: pluralize(self.audited_changes["comment_count"].last, "comentário"))
      }
      return [timeline_text, notification_texts]
    end

    if collaboration_created?
      timeline_text = I18n.t("audit.collaboration_created", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea))
      notification_texts = {
        creator: I18n.t("audit.notification.collaboration_created.creator", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea)),
        collaborators: I18n.t("audit.notification.collaboration_created.collaborators", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea))
      }
      return [timeline_text, notification_texts]
    end
    
    [nil, nil]
    
  end
  
  private
  
  def check_conditions(action, options = {})
    return false unless self.action == action
    if options.has_key?(:must_not_have_changed)
      options[:must_not_have_changed].each do |column|
        return false if self.audited_changes.has_key?(column.to_s)
      end
    end
    if options.has_key?(:must_have_changed)
      options[:must_have_changed].each do |column|
        return false unless self.audited_changes.has_key?(column.to_s)
      end
    end
    if options.has_key?(:must_have_changed_to)
      options[:must_have_changed_to].each do |column, value|
        begin
          check_value = self.audited_changes[column.to_s].last
        rescue
          check_value = self.audited_changes[column.to_s]
        end
        if value == :not_nil
          return false if check_value == nil
        elsif value == :nil
          return false unless check_value == nil
        else
          return false unless check_value == value
        end
      end
    end
    if options.has_key?(:must_not_have_changed_to)
      options[:must_not_have_changed_to].each do |column, value|
        begin
          check_value = self.audited_changes[column.to_s].last
        rescue
          check_value = self.audited_changes[column.to_s]
        end
        if value == :not_nil
          return false unless check_value == nil
        elsif value == :nil
          return false if check_value == nil
        else
          return false if check_value == value
        end
      end
    end
    true
  end
  
  def idea_created?
    check_conditions("create")
  end
  
  def edited_by_creator?
    check_conditions("update", must_not_have_changed: [:likes, :comment_count, :collaboration_count, :tokbox_session])
  end
  
  def likes_updated?
    check_conditions("update", must_have_changed: [:likes], must_not_have_changed_to: {likes: 0})
  end
  
  def comments_updated?
    check_conditions("update", must_have_changed: [:comment_count], must_not_have_changed_to: {comment_count: 0})
  end
  
  def collaboration_created?
    check_conditions("update", must_have_changed: [:collaboration_count], must_not_have_changed_to: {collaboration_count: 0})
  end
  
end
