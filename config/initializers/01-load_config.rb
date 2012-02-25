CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

require "koala"
oauth = Koala::Facebook::OAuth.new(CONFIG['facebook_app_id'], CONFIG['facebook_secret_key'], CONFIG['callback_url'])
CONFIG['facebook_access_token'] = oauth.get_app_access_token
