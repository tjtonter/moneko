require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Moneko
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Europe/Helsinki'
    config.beginning_of_week = :monday
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fi
    config.i18n.enforce_available_locales = true
    # For bootstrap glyphicons
    config.assets.paths << "#{Rails}/app/assets/fonts"
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.woff *.ttf *.eot *.svg)
    config.assets.digest = true
  end
end
