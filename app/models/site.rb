class Site < ActiveRecord::Base
  
  belongs_to :template
  has_many :users
  has_many :links
  validates_presence_of :name, :host, :template
  validates_uniqueness_of :name, :host

  def self.auth_gateway
    where(:auth_gateway => true).first
  end
  
  def full_url(path = "")
    "http://#{host}#{port ? ":#{port}" : ""}#{path}"
  end

end
