class IdeaCategory < ActiveRecord::Base
	has_many :ideas, :dependent => :destroy, :foreign_key => :category_id
	validates_presence_of :name

	#mount_uploader :badge, BadgeUploader

  def to_param
   "#{self.id}-#{self.name.parameterize}"
  end


  def badge
    result = case self.id
             when 1 then "/assets/badges/urban.png"
             when 2 then "/assets/badges/disasters.png"
             when 3 then "/assets/badges/security.png"
             else "/assets/badges/urban.png"
             end
  end
end
