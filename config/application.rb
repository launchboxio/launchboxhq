# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
Dotenv::Railtie.load if %w[development test].include? ENV['RAILS_ENV']

puts ENV.fetch('RAILS_ENV', nil)
module Launchboxhq
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_cable.url = '/cable'

    config.to_prepare do
      Devise::SessionsController.layout 'auth'
      Devise::RegistrationsController.layout 'auth'
      Devise::ConfirmationsController.layout 'auth'
      Devise::UnlocksController.layout 'auth'
      Devise::PasswordsController.layout 'auth'
    end

    config.launchbox = config_for(:launchbox)
  end
end
