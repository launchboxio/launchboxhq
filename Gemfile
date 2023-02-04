# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'jsbundling-rails'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.2', '>= 7.0.2.4'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
# gem "jbuilder", github: 'rails/jbuilder'
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', require: false
gem 'breadcrumbs', '~> 0.3.0'
gem 'dotenv-rails', '~> 2.8'
gem 'faraday', '~> 2.6'
gem 'gruf', '~> 2.16'
gem 'jsonapi-serializer', '~> 2.2'
gem 'rack-cors', '~> 1.1'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'paper_trail'
gem 'json-schema'
gem 'acts-as-taggable-on', '~> 9.0'

# Devise and doorkeeper
gem 'devise', '~> 4.8'
gem 'doorkeeper', '~> 5.6'
gem 'doorkeeper-openid_connect', '~> 1.8'

# Omniauth and providers
gem 'omniauth', '~> 2.1'
gem 'omniauth-atlassian-bitbucket'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-gitlab'

# Kubernetes SDKs
gem 'kubeclient', '~> 4.10'
gem 'rhelm', '~> 0.2.0'

# Datastores
gem 'haikunate', '~> 0.1.1'
gem 'pg', '~> 1.1'
gem 'redis', '~> 4.0'
gem 'vault', '~> 0.17.0'
gem 'vault-rails', '~> 0.8.0'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', '~> 1.38'
  gem 'rubocop-rails', '~> 2.17'
  gem 'rspec-rails'
end

group :development do
  gem 'grpc-tools', '~> 1.50'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'factory_bot_rails'
  gem 'faker'
end
