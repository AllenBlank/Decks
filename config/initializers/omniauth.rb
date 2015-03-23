OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['DECKS_FACEBOOK_APP_ID'], ENV['DECKS_FACEBOOK_APP_SECRET']
  provider :google_oauth2, ENV['DECKS_GOOGLE_KEY'], ENV['DECKS_GOOGLE_SECRET']
end