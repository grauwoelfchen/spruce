# config valid only for Capistrano 3.1
lock "3.2.1"

set :application, "spruce"
set :repo_url, "git@github.com:grauwoelfchen/spruce.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, :release

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/var/www/spruce"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, false

# Default value for :linked_files is []
set :linked_files, %w[.env Procfile config/newrelic.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w{
log
tmp/pids tmp/cache tmp/sockets
public/shared
bundle
node_modules
vendor/assets/components
}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

SSHKit.config.command_map[:rake] = "foreman run rake"

set :bundle_cmd, "source $HOME/.bashrc && bundle"

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, "cache:clear"
      # end
    end
  end
end

namespace :foreman do
  desc "Export runit configuration scripts"
  task :export do
    on roles(:app) do |host|
      within release_path do
        execute :bundle, <<-CMD.gsub(/\s{2}/, "")
exec \
foreman export runit $HOME/service \
  -f ./Procfile \
  -a #{fetch(:application)} \
  -l #{shared_path.join("log")} \
  -u #{host.user} \
  -t #{shared_path.join("runit-template")}
        CMD
      end
    end
  end

  {
    :app    => "unicorn",
    :worker => "worker"
  }.each do |type, process|
    namespace type do
      desc "Start"
      task :start do
        on roles(:app), wait: 20  do
          execute "sv -w 15 start $HOME/service/#{fetch(:application)}-#{process}-1"
        end
      end

      desc "Stop"
      task :stop do
        on roles(:app), wait: 60  do
          execute "sv -w 30 stop $HOME/service/#{fetch(:application)}-#{process}-1"
        end
      end

      desc "Restart"
      task :restart do
        on roles(:app), wait: 60 do
          execute "sv -w 30 restart $HOME/service/#{fetch(:application)}-#{process}-1"
        end
      end
    end
  end
end

after "deploy", "foreman:export"
after "deploy", "foreman:app:restart"

namespace :deploy do
  namespace :assets do
    desc "Install bower"
    task :install_bower do
      on roles(:app) do
        within release_path do
          execute "cd #{release_path}; npm install bower --quiet"
        end
      end
    end

    desc "Install components"
    task :install_components do
      on roles(:app) do
        within  release_path do
          execute "cd #{release_path}; ./node_modules/.bin/bower install"
        end
      end
    end
  end
end

# does not run every time
#before "deploy:assets:precompile", "deploy:assets:install_bower"
#before "deploy:assets:precompile", "deploy:assets:install_components"
