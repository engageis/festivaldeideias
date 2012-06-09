require 'opentok'
require 'pusher'
key, secret = "15793291", "b6f90ff600f642f98b00d044161cbee6996045ed"


unless Rails.env.production?
  CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
  ENV['FB_APP_ID'] = CONFIG['FB_APP_ID']
  ENV['FB_APP_SECRET'] = CONFIG['FB_APP_SECRET']
  ENV['FB_CALLBACK_URL'] = CONFIG['FB_CALLBACK_URL']
end

TOKBOX = OpenTok::OpenTokSDK.new key, secret
Pusher.app_id = '22022'
Pusher.key    = '3e107fc25d5330b3338b'
Pusher.secret = '2b7c5990aafe688f3080'
