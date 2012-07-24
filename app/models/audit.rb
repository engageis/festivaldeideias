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
      return I18n.t("audit.likes", idea: idea.title, idea_path: category_idea_path(idea.category, idea), likes: self.audited_changes[:likes].last)
    end

    if collaboration_sent?
      return I18n.t("audit.collaboration.sent", user: user.name, user_path: user_path(user), idea: self.parent.title, idea_path: category_idea_path(self.parent.category, self.parent))
    end
    
  end
  
  def parent
    return unless self.audited_changes[:parent_id]
    if self.action == "create"
      parent_id = self.audited_changes[:parent_id]
    else
      parent_id self.audited_changes[:parent_id].last
    end
    Idea.find(parent_id)
  end
  
  private
  
  def check_conditions(action, options = {})
    return false unless self.action == action
    if options.has_key?(:must_not_have_changed)
      options[:must_not_have_changed].each do |column|
        return false if self.audited_changes.has_key?(column)
      end
    end
    if options.has_key?(:must_have_changed)
      options[:must_have_changed].each do |column|
        return false unless self.audited_changes.has_key?(column)
      end
    end
    if options.has_key?(:must_have)
      options[:must_have].each do |column, value|
        if self.action == "create"
          check_value = self.audited_changes[column]
        else
          check_value self.audited_changes[column].last
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
    check_conditions("update", must_not_have_changed: [:accepted, :likes])
  end
  
  def likes_updated?
    check_conditions("update", must_have_changed: [:likes])
  end
  
  def collaboration_sent?
    check_conditions("create", must_have: { parent_id: :not_nil, accepted: :nil })
  end
  
end
