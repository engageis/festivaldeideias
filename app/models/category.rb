class Category < ActiveRecord::Base
  belongs_to :site
  validates_presence_of :name, :badge
  validates_uniqueness_of :name, :scope => :site_id
end
