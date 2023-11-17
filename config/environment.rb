# frozen_string_literal: true

require 'action_mailer'

ActionMailer::Base.smtp_settings = {
  user_name: 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
  password: ENV.fetch('SENDGRID_API_KEY', nil), # This is the secret sendgrid API key which was issued during API key creation
  domain: ENV.fetch('SENDGRID_DOMAIN', nil),
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
