class Message < ActiveRecord::Base
  attr_accessible :idea_id, :user_id, :text

  belongs_to :idea
  belongs_to :user
end
