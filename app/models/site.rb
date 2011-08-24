class Site < ActiveRecord::Base
  
  belongs_to :template
  has_many :users
  has_and_belongs_to_many :admins, :class_name => 'User'
  has_many :links
  has_many :ideas
  has_many :categories
  validates_presence_of :name, :host, :template
  validates_uniqueness_of :name, :host

  mount_uploader :image, SiteImageUploader

  def self.auth_gateway
    where(:auth_gateway => true).first
  end
  
  def full_url(path = "")
    "http://#{host}#{port ? ":#{port}" : ""}#{path}"
  end

  def deadline_finished?
    deadline ? deadline.past? : false
  end
end
