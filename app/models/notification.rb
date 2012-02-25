class Notification < ActiveRecord::Base

  validates_presence_of :message, :user_id

end
