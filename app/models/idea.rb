class Idea < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
  belongs_to :category
  validates_presence_of :site, :user, :category, :title, :headline
  validates_length_of :headline, :maximum => 140
end
