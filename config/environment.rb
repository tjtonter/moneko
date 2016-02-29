# Load the Rails application.
require File.expand_path('../application', __FILE__)
#RAILS_ENV = 'development'
RAILS_ENV = 'production'
ENV['GOOGLE_APPLICATION_CREDENTIALS']="/var/www/moneko/client_secrets.json"
# Initialize the Rails application.
Moneko::Application.initialize!
