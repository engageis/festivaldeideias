class Idea < ActiveRecord::Base

  validates_presence_of :title, :headline
  belongs_to :user
  belongs_to :parent, :class_name => :Idea, :foreign_key => :parent_id
end
