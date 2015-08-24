Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["AUTH_GOOGLE_KEY"], ENV["AUTH_GOOGLE_SECRET"]
end
