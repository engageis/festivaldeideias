class IdeaCategory < ActiveRecord::Base
	has_many :ideas, :dependent => :destroy, :foreign_key => :category_id, conditions: ['parent_id IS NULL']
	has_many :colaborations, :dependent => :destroy, :foreign_key => :category_id, conditions: ['parent_id IS NOT NULL']

	validates_presence_of :name

  mount_uploader :badge, ImageUploader
  mount_uploader :pin, ImageUploader

  def to_param
   "#{self.id}-#{self.name.parameterize}"
  end

end
