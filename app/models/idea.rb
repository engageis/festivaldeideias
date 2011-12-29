class Idea < ActiveRecord::Base

  validates_presence_of :title, :headline
  belongs_to :user
end
