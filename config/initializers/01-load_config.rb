require 'opentok'
require 'pusher'
CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
ENV['TOKBOX_API_URL']     = CONFIG['TOKBOX_API_URL']
ENV['TOKBOX_JS_URL']      = CONFIG['TOKBOX_JS_URL']

unless Rails.env.production?
  ENV['FB_APP_ID']        = CONFIG['FB_APP_ID']
  ENV['FB_APP_SECRET']    = CONFIG['FB_APP_SECRET']
  ENV['FB_CALLBACK_URL']  = CONFIG['FB_CALLBACK_URL']
  ENV['TOKBOX_KEY']       = CONFIG['TOKBOX_KEY']
  ENV['TOKBOX_SECRET']    = CONFIG['TOKBOX_SECRET']
  ENV['PUSHER_KEY']       = CONFIG['PUSHER_KEY']
  ENV['PUSHER_SECRET']    = CONFIG['PUSHER_SECRET']
end

TOKBOX = OpenTok::OpenTokSDK.new(
  ENV['TOKBOX_KEY'], 
  ENV['TOKBOX_SECRET'], 
  :api_url => ENV['TOKBOX_API_URL']
)

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
