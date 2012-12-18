class Collaborator < ActiveRecord::Base
  belongs_to :idea
  belongs_to :user
  validates_presence_of :idea_id, :user_id
  validates_uniqueness_of :user_id, scope: :idea_id
end
