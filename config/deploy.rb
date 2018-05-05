# config valid only for current version of Capistrano
lock '3.10.1'

set :application, 'time-tracker'
set :repo_url, 'git@git.thm.de:mhpp11/time-tracker.git'

set :systemd_use_sudo, true
set :systemd_roles, %w(app)


append :linked_files, 'config/puma.rb', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'private/uploads'

set :keep_releases, 5

set :maintenance_template_path, File.expand_path("../../app/views/maintenance.html.erb", __FILE__)

# set :slackistrano, {
#     channel: '#server',
#     webhook: 'https://hooks.slack.com/services/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'
# }

namespace :deploy do
  namespace :db do
    desc 'drop all tables in db and setup the db with seed'
    task reset: [:set_rails_env] do
      on fetch(:migration_servers) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :psql, "-c 'drop owned by development'"
            execute :rake, 'db:migrate'
            execute :rake, 'db:setup'
          end
        end
      end
    end

    desc 'reload the database with seed data'
    task seed: [:set_rails_env] do
      on fetch(:migration_servers) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:seed'
          end
        end
      end
    end

    desc 'backup postgres data'
    task :backup do
      on roles(:db) do |host|
        path = "#{deploy_to}/dumps/"
        filename = "#{path}gildamesh.#{release_timestamp}.sql"
        if test "[ ! -d #{path} ]"
          execute :mkdir, "#{path}"
        end
        execute :pg_dump, "#{fetch(:database)} > \"#{filename}\""
      end
    end

    desc 'clean up postgres backups, keeps the last 10 dumps'
    task :cleanup do
      on roles(:db) do |host|
        path = "#{deploy_to}/dumps/"
        puts "Keeping the 10 database dumps"
        execute :ls, "-tp #{path} | grep -v '/$' | tail -n +10 | xargs -I {} rm -- \"#{path}{}\""
      end
    end
  end
end

before "deploy:migrate", "db:backup"
after  "deploy:cleanup", "db:cleanup"
