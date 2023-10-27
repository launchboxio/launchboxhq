# frozen_string_literal: true

FactoryBot.define do
  factory :cluster do
    name { Faker::Lorem.word }
    slug { Faker::Internet.slug }
    region { 'us-east-1' }
    version { Faker::App.semantic_version }
    provider { 'aws' }
    status { Faker::Boolean.boolean }
    oauth_application do
      Doorkeeper::Application.create!(name: SecureRandom.uuid, confidential: true, redirect_uri: 'https://localhost:8080')
    end
  end

  factory 'doorkeeper/application' do
    name { Faker::App.name }
    uid { Faker::Internet.uuid }
    secret { Faker::Internet.uuid }
    redirect_uri { Faker::Internet.url(scheme: 'https') }
  end

  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { DateTime.now }
  end

  factory :addon do
    name { Faker::App.name }
    json_schema { '{a: b}' }
  end

  factory :project do
    name { Faker::App.name }
  end

  factory 'doorkeeper/access_token' do; end
end
