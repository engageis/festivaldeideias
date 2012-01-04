class IdeaCategory < ActiveRecord::Base
  has_many :ideas
  validates_presence_of :name, :badge

  mount_uploader :badge, BadgeUploader
end
