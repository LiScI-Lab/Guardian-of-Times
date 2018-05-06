Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  if Settings.omniauth.providers.enabled.include? :cas3
    raise 'Configuration incomplete for cas3' if Settings.omniauth.cas3.name.blank? or Settings.omniauth.cas3.host.blank? or Settings.omniauth.cas3.service_validate_url.blank? or Settings.omniauth.cas3.uid_field.blank?
    provider :cas3, host: Settings.omniauth.cas3.host, ssl: true, service_validate_url: Settings.omniauth.cas3.service_validate_url, uid_field: Settings.omniauth.cas3.uid_field
  end

  if Settings.omniauth.providers.enabled.include? :google_oauth2
    raise 'Configuration incomplete for google' if Settings.omniauth.google_oauth2.client_id.blank? or Settings.omniauth.google_oauth2.client_secret.blank?
    provider :google_oauth2, Settings.omniauth.google_oauth2.client_id, Settings.omniauth.google_oauth2.client_secret
  end

  if Settings.omniauth.providers.enabled.include? :twitter
    raise 'Configuration incomplete for twitter' if Settings.omniauth.twitter.key.blank? or Settings.omniauth.twitter.secret.blank?
    provider :twitter, Settings.omniauth.twitter.key, Settings.omniauth.twitter.secret
  end

  if Settings.omniauth.providers.enabled.include? :github
    raise 'Configuration incomplete for github' if Settings.omniauth.github.key.blank? or Settings.omniauth.github.secret.blank?
    provider :github, Settings.omniauth.github.key, Settings.omniauth.github.secret
  end

  if Settings.omniauth.providers.enabled.include? :facebook
    raise 'Configuration incomplete for facebook' if Settings.omniauth.facebook.key.blank? or Settings.omniauth.facebook.secret.blank?
    provider :facebook, Settings.omniauth.facebook.key, Settings.omniauth.facebook.secret
  end

  if Settings.omniauth.providers.enabled.include? :windowslive
    raise 'Configuration incomplete for steam' if Settings.omniauth.windowslive.client_id.blank? or Settings.omniauth.windowslive.secret.blank?
    provider :windowslive, Settings.omniauth.windowslive.client_id, Settings.omniauth.windowslive.secret, scope: 'wl.basic'
  end

  if Settings.omniauth.providers.enabled.include? :xing
    raise 'Configuration incomplete for xing' if Settings.omniauth.xing.consumer_key.blank? or Settings.omniauth.xing.consumer_secret.blank?
    provider :xing, Settings.omniauth.xing.consumer_key, Settings.omniauth.xing.consumer_secret
  end

  if Settings.omniauth.providers.enabled.include? :linkedin
    raise 'Configuration incomplete for linkedin' if Settings.omniauth.linkedin.key.blank? or Settings.omniauth.linkedin.secret.blank?
    provider :linkedin, Settings.omniauth.linkedin.key, Settings.omniauth.linkedin.secret
  end


  if Settings.omniauth.providers.enabled.include? :slack
    raise 'Configuration incomplete for slack' if Settings.omniauth.slack.key.blank? or Settings.omniauth.slack.secret.blank?
    provider :slack, Settings.omniauth.slack.key, Settings.omniauth.slack.secret, scope: 'identity.basic'
  end


  if Settings.omniauth.providers.enabled.include? :steam
    raise 'Configuration incomplete for steam' if Settings.omniauth.steam.key.blank?
    provider :github, Settings.omniauth.steam.key
  end
end
