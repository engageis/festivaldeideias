class Merge < ActiveRecord::Base
  belongs_to :idea
  belongs_to :from, :class_name => 'Idea', :foreign_key => :from_id
  validates_presence_of :idea, :from
end
