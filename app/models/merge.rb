class Merge < ActiveRecord::Base
  belongs_to :idea
  belongs_to :from, :class_name => 'Idea', :foreign_key => :from_id
  validates_presence_of :idea, :from
  scope :requested, where(:requested => true)
  scope :pending, where(:pending => true)
  scope :finished, where(:finished => true)
  def self.merges_from(from_id)
    where(:from_id => from_id)
  end
end
