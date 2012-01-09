class Idea < ActiveRecord::Base

  validates_presence_of :title, :headline, :category
  belongs_to :user
  belongs_to :category, :class_name => "IdeaCategory", :foreign_key => :category_id
  belongs_to :parent, :class_name => :Idea, :foreign_key => :parent_id

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
