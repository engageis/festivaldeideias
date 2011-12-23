# We are requiring the omniauth lib
require "openid/store/filesystem"
Rails.application.config.middleware.use OmniAuth::Builder do

  # Urls
  # Facebook: https://developers.facebook.com/setup
  # Twitter: https://developer.twitter.com/apps/new

  # When modified (this file), you should restart you server :)


  # List of authorized providers for this app
  # For heroku, using "./tmp"

  provider :facebook, "id", "secret"
  provider :twitter, "key", "secret"

end
