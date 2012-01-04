class IdeaCategory < ActiveRecord::Base
  has_many :ideas, :dependent => :destroy
  validates_presence_of :name, :badge

  mount_uploader :badge, BadgeUploader


  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
end
