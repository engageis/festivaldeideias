class User < ActiveRecord::Base
  # User has many types of services (facebook, twitter and so on)
  has_many :services
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  attr_accessible :name, :email
end
