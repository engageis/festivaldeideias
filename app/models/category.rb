class Category < ActiveRecord::Base

  belongs_to :site
  has_many :ideas
  validates_presence_of :name, :badge
  validates_uniqueness_of :name, :scope => :site_id

  scope :with_ideas, where("id IN (SELECT DISTINCT category_id FROM ideas)")

  def as_json(options={})
    {
      :id => id,
      :name => name,
      :badge => badge
    }
  end
  
end
