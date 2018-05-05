Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  if Settings.omniauth.cas3.enabled
    provider :cas3, host: Settings.omniauth.cas3.host, ssl: true, service_validate_url: Settings.omniauth.cas3.service_validate_url, uid_field: Settings.omniauth.cas3.uid_field
  end

  if Settings.omniauth.google.enabled
    provider :google_oauth2, Settings.omniauth.google.client_id, Settings.omniauth.google.client_secret
  end

  if Settings.omniauth.twitter.enabled
    provider :twitter, Settings.omniauth.twitter.key, Settings.omniauth.twitter.secret
  end

  if Settings.omniauth.github.enabled
    provider :github, Settings.omniauth.github.key, Settings.omniauth.github.secret
  end
end
