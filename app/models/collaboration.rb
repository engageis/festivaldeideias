class Collaboration < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  belongs_to :parent, :class_name => "Collaboration", :foreign_key => :parent_id
  validates_presence_of :idea_id, :user_id, :description
  attr_accessible :accepted, :description, :parent_id, :idea_id, :user_id
  
  after_create :update_idea_and_collaborators
  
  def update_idea_and_collaborators
    self.idea.update_attribute :collaboration_count, self.idea.collaborations.count
    self.idea.collaborators.create user: self.user
  end
  
end
