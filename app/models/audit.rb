# coding: utf-8

class Audit < ActiveRecord::Base

  belongs_to :user
  belongs_to :idea, foreign_key: :auditable_id
  belongs_to :actual_user, class_name: "User", foreign_key: :actual_user_id
  belongs_to :parent, class_name: "Idea", foreign_key: :parent_id
  serialize :audited_changes
  serialize :notification_texts
  
  scope :recent, where("timeline_type IS NOT NULL AND timeline_type <> 'ignore'").order("created_at DESC").limit(100)
  scope :pending, where("timeline_type IS NULL")

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper

  # IMPORTANT NOTICE for developers: this method is called by migration StoreAuditsTimelineData.
  # If you remove it or change its behaviour, please edit the migration as well
  def set_timeline_and_notifications_data!
    self.timeline_type = generated_timeline_type
    self.actual_user_id = generated_actual_user_id
    self.parent_id = generated_parent_id
    self.text, self.notification_texts = generated_texts
    self.save
  end
  
  def generated_timeline_type
    return "ignore" unless self.idea
    return "idea_created" if idea_created?
    return "edited_by_creator" if edited_by_creator?
    return "likes_updated" if likes_updated?
    return "comments_updated" if comments_updated?
    return "collaboration_sent" if collaboration_sent?
    return "collaboration_accepted" if collaboration_accepted?
    return "collaboration_rejected" if collaboration_rejected?
    return "idea_ramified" if idea_ramified?
    "ignore"
  end
  
  def generated_actual_user_id
    return unless self.idea
    return self.idea.user_id if self.idea and ["likes_updated", "comments_updated"].include?(self.timeline_type)
    return self.idea.parent.user_id if self.idea and self.idea.parent and ["collaboration_accepted", "collaboration_rejected"].include?(self.timeline_type)
    self.user_id or self.idea.user_id
  end
  
  def generated_parent_id
    return unless self.idea
    generated_parent_id = nil
    if self.audited_changes
      begin
        generated_parent_id = self.audited_changes["parent_id"].last
      rescue
        generated_parent_id = self.audited_changes["parent_id"]
      end
    end
    generated_parent_id = self.idea.parent_id unless generated_parent_id.present?
    generated_parent_id = self.idea.original_parent_id unless generated_parent_id.present?
    generated_parent_id
  end
  
  def generated_texts

    return [nil, nil] unless self.idea

    if idea_created?
      timeline_text = I18n.t("audit.create", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: idea.title, idea_path: category_idea_path(idea.category, idea))
      notification_texts = nil
      return [timeline_text, notification_texts]
    end
    
    if edited_by_creator?
      timeline_text = I18n.t("audit.edit", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: idea.title, idea_path: category_idea_path(idea.category, idea))
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

    if collaboration_sent?
      timeline_text = I18n.t("audit.collaboration.sent", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      notification_texts = {
        creator: I18n.t("audit.notification.collaboration.sent.creator", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent)),
        collaborators: I18n.t("audit.notification.collaboration.sent.collaborators", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      }
      return [timeline_text, notification_texts]
    end
    
    if collaboration_accepted?
      timeline_text = I18n.t("audit.collaboration.accepted", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      notification_texts = {
        collaborators: I18n.t("audit.notification.collaboration.accepted.collaborators", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent)),
        accepted_collaborator: I18n.t("audit.notification.collaboration.accepted.accepted_collaborator", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      }
      return [timeline_text, notification_texts]
    end
    
    if collaboration_rejected?
      timeline_text = I18n.t("audit.collaboration.rejected", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      notification_texts = {
        collaborators: I18n.t("audit.notification.collaboration.rejected.collaborators", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent)),
        rejected_collaborator: I18n.t("audit.notification.collaboration.rejected.rejected_collaborator", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent), ramify_path: ramify_idea_path(self.idea))
      }
      return [timeline_text, notification_texts]
    end
    
    if idea_ramified?
      timeline_text = I18n.t("audit.collaboration.ramified", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: self.actual_user.name, collaborator_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
      notification_texts = {
        creator: I18n.t("audit.notification.collaboration.ramified.creator", collaborator: self.actual_user.name, collaborator_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent)),
        collaborators: I18n.t("audit.notification.collaboration.ramified.collaborators", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: self.actual_user.name, collaborator_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
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
    check_conditions("create", must_not_have_changed_to: { parent_id: :not_nil })
  end
  
  def edited_by_creator?
    check_conditions("update", must_not_have_changed: [:accepted, :parent_id, :original_parent_id, :likes, :comment_count, :tokbox_session])
  end
  
  def likes_updated?
    check_conditions("update", must_have_changed: [:likes])
  end
  
  def comments_updated?
    check_conditions("update", must_have_changed: [:comment_count], must_not_have_changed_to: {comment_count: 0})
  end
  
  def collaboration_sent?
    check_conditions("create", must_have_changed_to: { parent_id: :not_nil, accepted: :nil })
  end
  
  def collaboration_accepted?
    check_conditions("update", must_have_changed_to: { accepted: true })
  end
  
  def collaboration_rejected?
    check_conditions("update", must_have_changed_to: { accepted: false })
  end
  
  def idea_ramified?
    check_conditions("update", must_have_changed_to: { parent_id: :nil, accepted: :nil, original_parent_id: :not_nil })
  end
  
end
