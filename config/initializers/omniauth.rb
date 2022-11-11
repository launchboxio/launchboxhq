Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :github
end