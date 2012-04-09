class IdeaCategory < ActiveRecord::Base
	has_many :ideas, :dependent => :destroy, :foreign_key => :category_id
	validates_presence_of :name


  def to_param
   "#{self.id}-#{self.name.parameterize}"
  end


  def badge
    result = case self.id
             when 1 then "/assets/badges/urban.png"
             when 2 then "/assets/badges/disasters.png"
             when 3 then "/assets/badges/security.png"
             when 4 then "/assets/badges/business.png"
             when 5 then "/assets/badges/learning.png"
             when 6 then "/assets/badges/volunteer.png"
             when 7 then "/assets/badges/apps.png"
             else "/assets/badges/urban.png"
             end
  end
end
