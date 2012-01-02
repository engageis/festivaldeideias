class Idea < ActiveRecord::Base

  validates_presence_of :title, :headline
  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :idea_category_id
  belongs_to :parent, :class_name => :Idea, :foreign_key => :parent_id
end
