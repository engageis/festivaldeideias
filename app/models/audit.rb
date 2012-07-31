# coding: utf-8

class Audit < ActiveRecord::Base

  belongs_to :user
  belongs_to :idea, foreign_key: :auditable_id
  serialize :audited_changes
  
  scope :recent, order("created_at DESC").limit(70)
  
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TextHelper
  
  def actual_user
    return self.idea.user if self.idea and ["likes_updated", "comments_updated"].include?(self.timeline_type)
    return self.idea.parent.user if self.idea and self.idea.parent and ["collaboration_accepted", "collaboration_rejected"].include?(self.timeline_type)
    self.user or self.idea.user
  end
  
  def text

    return nil unless self.idea

    if idea_created?
      return I18n.t("audit.create", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: idea.title, idea_path: category_idea_path(idea.category, idea))
    end
    
    if edited_by_creator?
      return I18n.t("audit.edit", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: idea.title, idea_path: category_idea_path(idea.category, idea))
    end
    
    if likes_updated?
      return I18n.t("audit.likes", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), likes: pluralize(self.audited_changes["likes"].last, "pessoa"))
    end

    if comments_updated?
      return I18n.t("audit.comments", idea: self.idea.title, idea_path: category_idea_path(self.idea.category, self.idea), comments: pluralize(self.audited_changes["comment_count"].last, "comentário"))
    end

    if collaboration_sent?
      return I18n.t("audit.collaboration.sent", user: self.actual_user.name, user_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if collaboration_accepted?
      return I18n.t("audit.collaboration.accepted", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if collaboration_rejected?
      return I18n.t("audit.collaboration.rejected", user: self.actual_user.name, user_path: user_path(self.actual_user), collaborator: self.idea.user.name, collaborator_path: user_path(self.idea.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if idea_ramified?
      return I18n.t("audit.collaboration.ramified", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: self.actual_user.name, collaborator_path: user_path(self.actual_user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    nil
    
  end
  
  def parent
    begin
      parent_id = self.audited_changes["parent_id"].last
    rescue
      parent_id = self.audited_changes["parent_id"]
    end
    parent_id = self.idea.parent_id unless parent_id.present?
    parent_id = self.idea.original_parent_id unless parent_id.present?
    Idea.find(parent_id) if parent_id.present?
  end
  
  private
  
  def check_conditions(type, action, options = {})
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
    self.timeline_type = type
    self.save
  end
  
  def idea_created?
    check_conditions("idea_created", "create", must_not_have_changed_to: { parent_id: :not_nil })
  end
  
  def edited_by_creator?
    check_conditions("edited_by_creator", "update", must_not_have_changed: [:accepted, :parent_id, :original_parent_id, :likes, :comment_count, :tokbox_session])
  end
  
  def likes_updated?
    check_conditions("likes_updated", "update", must_have_changed: [:likes])
  end
  
  def comments_updated?
    check_conditions("comments_updated", "update", must_have_changed: [:comment_count], must_not_have_changed_to: {comment_count: 0})
  end
  
  def collaboration_sent?
    check_conditions("collaboration_sent", "create", must_have_changed_to: { parent_id: :not_nil, accepted: :nil })
  end
  
  def collaboration_accepted?
    check_conditions("collaboration_accepted", "update", must_have_changed_to: { accepted: true })
  end
  
  def collaboration_rejected?
    check_conditions("collaboration_rejected", "update", must_have_changed_to: { accepted: false })
  end
  
  def idea_ramified?
    check_conditions("idea_ramified", "update", must_have_changed_to: { parent_id: :nil, accepted: :nil, original_parent_id: :not_nil })
  end
  
end
