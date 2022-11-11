source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.2", ">= 7.0.2.4"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
# gem "jbuilder", github: 'rails/jbuilder'
gem "dotenv-rails", "~> 2.8"
gem "bcrypt", "~> 3.1"
gem "rack-cors", "~> 1.1"
gem "faraday", "~> 2.6"
gem "breadcrumbs", "~> 0.3.0"
gem "jsonapi-serializer", "~> 2.2"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

# Devise and doorkeeper
gem "devise", "~> 4.8"
gem "doorkeeper", "~> 5.6"
gem "doorkeeper-openid_connect", "~> 1.8"

# Omniauth and providers
gem "omniauth", "~> 2.1"
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-gitlab'
gem 'omniauth-atlassian-bitbucket'

# Kubernetes SDKs
gem "kubeclient", "~> 4.10"
gem "rhelm", "~> 0.2.0"

# Datastores
gem "pg", "~> 1.1"
gem "redis", "~> 4.0"
gem "vault", "~> 0.17.0"
gem "vault-rails", "~> 0.8.0"
gem "haikunate", "~> 0.1.1"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
