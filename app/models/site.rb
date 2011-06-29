class Site < ActiveRecord::Base
  
  validates_presence_of :name, :host
  validates_uniqueness_of :name, :host
  has_many :users

  def self.auth_gateway
    where(:auth_gateway => true).first
  end
  
  def full_url(path = "")
    "http://#{host}#{port ? ":#{port}" : ""}#{path}"
  end

end
