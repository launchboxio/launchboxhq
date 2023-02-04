FactoryBot.define do
  factory :cluster do
    name { Faker::Lorem.word }
    slug { Faker::Internet.slug }
    region { 'us-east-1' }
    version { Faker::App.semantic_version }
    provider { 'aws' }
    status { Faker::Boolean.boolean }
  end

  factory 'doorkeeper/application' do
    name { Faker::App.name }
    uid { Faker::Internet.uuid }
    secret { Faker::Internet.uuid }
    redirect_uri { Faker::Internet.url(scheme: 'https')  }
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

  factory 'doorkeeper/access_token' do; end
end