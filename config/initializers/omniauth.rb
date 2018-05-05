Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :cas3, host: 'cas.thm.de', ssl: true, service_validate_url: '/cas/serviceValidate', uid_field: 'username'

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end
