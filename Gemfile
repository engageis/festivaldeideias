source 'http://rubygems.org'

# Framework
gem 'rails', '>= 3.2.6'


# Database
gem 'pg'
gem 'foreigner'
gem "audited-activerecord"

# Differ tool
gem 'differ'

# Geolocalization
gem "geocoder"

# Controller improvements 
gem 'inherited_resources'
gem 'has_scope'

# Administration & dependencies
gem 'activeadmin'
gem "devise", "2.0.4"
gem 'meta_search'
gem 'pg_search'

# Tools
gem 'simple_form'
gem 'kaminari'
gem 'carrierwave'
gem 'fog'
gem 'auto_html'
gem 'friendly_id'
gem 'tinymce-rails'
gem 'koala'

# Cocreation Room
gem 'opentok'
gem 'pusher'

# Authentication + Authorization
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'

# Frontend stuff
gem 'jquery-rails'
gem 'slim'
gem 'rails-backbone'
gem 'rack-pjax'

# Heroku
gem 'thin'
# Removing heroku gem in order to use the Toolbelt
# gem 'heroku'

group :development do
  gem 'taps'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem "selenium-webdriver", "~>2.25", require: false
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'database_cleaner'
  gem "shoulda-matchers"
  gem 'rb-fsevent'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'jasmine'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'compass-rails'
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'compass-960-plugin'
  gem 'uglifier'
end