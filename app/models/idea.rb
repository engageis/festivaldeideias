class Idea < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
  belongs_to :category
  belongs_to :template
  belongs_to :parent, :class_name => 'Idea', :foreign_key => :parent_id
  validates_presence_of :site, :user, :category, :template, :title, :headline
  validates_length_of :headline, :maximum => 140
end
