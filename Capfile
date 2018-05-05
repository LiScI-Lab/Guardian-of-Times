# Load DSL and set up stages
require "capistrano/setup"
require 'capistrano/maintenance'
# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/pending'


# [Deprecation Notice] Future versions of Capistrano will not load the Git SCM
# plugin by default. To silence this deprecation warning, add the following to
# your Capfile:

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/rvm'
require 'capistrano/systemd'

# require 'slackistrano/capistrano'


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each {|r| import r}
