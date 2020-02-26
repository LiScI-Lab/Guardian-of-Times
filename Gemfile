source 'https://rubygems.org'

gem 'config'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'

gem 'slim'
gem 'slim-rails'

gem 'material_icons'
gem 'material_design_icons'

# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# MaterializeCSS
gem 'materialize-sass'#, '~> 1.0.0.beta'
gem 'materialize-form'
gem 'ancestry'

# Nested Forms helper
gem 'cocoon'

#pdf generation through wicked & wkhtmltopdf
gem 'wicked_pdf'
group :wk_binary do
  gem 'wkhtmltopdf-binary'
end

# better distance_of_time_in_words
gem 'dotiw'
# better duration printing
gem 'chronic_duration'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# AsciiDoc support
gem 'asciidoctor'
gem 'asciidoctor-rouge'
gem 'rouge'
gem 'rouge-rails'

# Creates Administration system
gem 'activeadmin'

# Creating graphs with less work - Read more: http://chartkick.com/
gem 'chartkick'
gem 'chartjs-ror'

#date&time grouping
gem 'groupdate'
#date & time validations
gem 'validates_timeliness'
gem 'timeliness-i18n'

# Nested Forms helper
#gem 'cocoon'

gem 'devise'
gem 'simple_token_authentication'
gem 'devise-i18n'

gem 'omniauth'
gem 'omniauth-cas3'
gem 'omniauth-google-oauth2', '>= 0.8.0'
gem 'omniauth-twitter'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-facebook'
gem 'omniauth-windowslive'
gem 'omniauth-xing'
gem 'omniauth-linkedin-oauth2'
#gem 'omniauth-slack'
gem 'omniauth-steam'

#JWT for API-Token
gem 'jwt'


gem 'acts-as-taggable-on'

# Upload files with Carrierwave. Read more here: https://github.com/carrierwaveuploader/carrierwave
gem 'carrierwave'

# CanCanCan - User authorisation. More here: https://github.com/CanCanCommunity/cancancan
gem 'cancancan', '~> 2.0'

gem 'discard' # replaces paranoia

gem 'simple_form'
gem 'time_splitter'
gem 'identicon'
# Faker - Generator for fake Date
gem 'faker'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'http_accept_language'
gem 'rails-i18n'
gem 'i18n-js'
gem 'momentjs-rails'
gem 'enum_help'

group :development, :test do
  # Adds support for Capybara system testing and selenium driver
  #gem 'capybara', '~> 2.13'
  #gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'factory_bot'
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'rails-plantuml-generator', git: 'https://github.com/HappyKadaver/rails-plantuml-generator'
  gem 'i18n-debug'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'better_errors'
  gem 'binding_of_caller'

  # Capistrano for Deployment to server
  gem 'capistrano', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false

  gem 'capistrano-systemd', require: false

  gem 'capistrano-maintenance', require: false
  gem 'capistrano-pending', require: false

  #better repl & repl-doc browsing
  gem 'pry-rails'
  gem 'pry-doc'
end

group :production do
  gem 'pg'
end
