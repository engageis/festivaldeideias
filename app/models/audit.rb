class Audit < ActiveRecord::Base

  belongs_to :user
  belongs_to :idea, foreign_key: :auditable_id
  serialize :audited_changes
  
  include Rails.application.routes.url_helpers
  
  def text

    if edited_by_creator?
      return I18n.t("audit.edit", user: user.name, user_path: user_path(user), idea: idea.title, idea_path: category_idea_path(idea.category, idea))
    end
    
    if likes_updated?
      return I18n.t("audit.likes", idea: idea.title, idea_path: category_idea_path(idea.category, idea), likes: self.audited_changes["likes"].last)
    end

    if collaboration_sent?
      return I18n.t("audit.collaboration.sent", user: user.name, user_path: user_path(user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if collaboration_accepted?
      return I18n.t("audit.collaboration.accepted", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: self.user.name, collaborator_path: user_path(self.user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if collaboration_rejected?
      return I18n.t("audit.collaboration.rejected", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: user.name, collaborator_path: user_path(user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
    if idea_ramified?
      return I18n.t("audit.collaboration.ramified", user: self.parent.user.name, user_path: user_path(self.parent.user), collaborator: user.name, collaborator_path: user_path(user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
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
    true
  end
  
  def edited_by_creator?
    check_conditions("update", must_not_have_changed: [:accepted, :parent_id, :likes, :tokbox_session])
  end
  
  def likes_updated?
    check_conditions("update", must_have_changed: [:likes])
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
    check_conditions("update", must_have_changed_to: { parent_id: nil, accepted: nil, original_parent_id: :not_nil })
  end
  
end
