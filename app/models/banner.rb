class Banner < ActiveRecord::Base

  attr_accessible :title, :description, :link_text, :link_url, :image_url, :visible

  validates_presence_of :title, :description, :link_text, :link_url, :image_url

  def self.latest
    @latest = where(visible: true).order("updated_at DESC").limit(1)
    @latest.first
  end
  
end
