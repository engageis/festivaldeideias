class Message < ActiveRecord::Base
  attr_accessible :idea_id, :text, :user_id

  belongs_to :idea
end
