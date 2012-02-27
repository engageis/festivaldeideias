# We are requiring the omniauth lib
Rails.application.config.middleware.use OmniAuth::Builder do

  # Urls
  # Facebook: https://developers.facebook.com/setup
  # Twitter: https://developer.twitter.com/apps/new

  # When modified (this file), you should restart you server :)


  # List of authorized providers for this app
  # App ID:	142951129148413
  # App Secret:	ab9bb6972624b3f2ff3e09cce1cb062

  provider(:facebook,
           CONFIG['facebook_app_id'],
           CONFIG['facebook_secret_key'],
           :scope => "email,offline_access,create_event,user_location")

  #provider :twitter, "key", "secret"

end
