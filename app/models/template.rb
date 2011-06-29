class Template < ActiveRecord::Base
  
  has_many :sites
  has_many :ideas
  validates_presence_of :name
  validates_uniqueness_of :name

end
