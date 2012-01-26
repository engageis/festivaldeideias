class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  validates_presence_of :title
  validates_presence_of :body
  validates_uniqueness_of :title

  def should_generate_new_friendly_id?
    new_record?
  end
end
