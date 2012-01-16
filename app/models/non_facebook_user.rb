# coding: utf-8

class NonFacebookUser < ActiveRecord::Base
  # TODO: validar formato do email
  validates_presence_of :email
end
