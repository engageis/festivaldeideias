class User < ActiveRecord::Base
  # User has many types of services (facebook, twitter and so on)
  has_many :services
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  attr_accessible :name, :email


  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'], :email => hash['user_info']['email'])
  end
end
