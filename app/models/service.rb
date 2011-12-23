class Service < ActiveRecord::Base
  # A service belongs to an User, which can have multiple services.
  belongs_to :user
  validates_presence_of :uid, :uname, :uemail, :provider
  attr_accessible :provider, :uid, :uname, :uemail
end
