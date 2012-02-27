# coding: utf-8

require 'koala'
require 'json'

=begin
  Meu id: 100002129060701
  Id do Festival de ideias: 211024602327337
  Id do Festival teste: 191020401004722
=end

class FacebookEvents
  #@@oauth = Koala::Facebook::OAuth.new(CONFIG['facebook_app_id'],
                                       #CONFIG['facebook_secret_key'],
                                       #CONFIG['callback_url'])
  def self.get_token
    oauth = Koala::Facebook::OAuth.new(CONFIG['facebook_app_id'],
                                       CONFIG['facebook_secret_key'],
                                       CONFIG['callback_url'])
    return oauth.get_app_access_token
  end
end
