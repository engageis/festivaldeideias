unless Rails.env.production?
  CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
  ENV['FB_APP_ID'] = CONFIG['FB_APP_ID']
  ENV['FB_APP_SECRET'] = CONFIG['FB_APP_SECRET']
  ENV['FB_CALLBACK_URL'] = CONFIG['FB_CALLBACK_URL']
end
