class Collaborator < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  validates_presence_of :idea_id, :user_id
end
