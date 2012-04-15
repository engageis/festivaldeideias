# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FestivalDeIdeias::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'festivaldeideias.org.br',
  :enable_starttls_auto => true
}
