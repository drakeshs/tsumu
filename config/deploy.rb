# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'tsumu'
set :repo_url, 'git@github.com:josetonyp/tsumu.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/application'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/mongoid.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log log/pids tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/system public/assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_path, "/opt/rbenv"
set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Defautl capistrano bundler gem config options
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, ''
set :bundle_without, %w{test development}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all
set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :puma_threads, [0, 16]
set :puma_workers, 5
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, true
set :puma_bind, %w(tcp://0.0.0.0:9292 unix:///tmp/application.socket)



set :sidekiq_default_hooks,  true
set :sidekiq_pid,  File.join(shared_path, 'log', 'pids', 'sidekiq.pid')
set :sidekiq_env,  fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :sidekiq_log,  File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_timeout,  10
set :sidekiq_role,  :app
set :sidekiq_processes,  1
set :sidekiq_concurrency, 6
# set :sidekiq_options,  nil
# set :sidekiq_require, nil
# set :sidekiq_tag, nil
# set :sidekiq_config, nil
# set :sidekiq_queue, nil

after 'deploy:publishing', "puma:stop"
after 'deploy:publishing', 'sidekiq:rolling_restart'
after 'deploy:publishing', "puma:start"
after 'deploy:publishing', "puma:workers:count"

