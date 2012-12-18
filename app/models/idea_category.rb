class IdeaCategory < ActiveRecord::Base
	has_many :ideas, :dependent => :destroy, :foreign_key => :category_id

	validates_presence_of :name

  mount_uploader :badge, ImageUploader
  mount_uploader :pin, ImageUploader

  def to_param
   "#{self.id}-#{self.name.parameterize}"
  end

end
