require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TimeTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.autoload_paths += %W(#{config.root}/lib)

    #TODO: add english translations
    config.i18n.available_locales = %w(de en)
    config.i18n.default_locale = 'de'
    config.time_zone = 'Berlin'

    #TODO: update this when using postgres !!!
    # => SQLite does not support timezones while grouping

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
