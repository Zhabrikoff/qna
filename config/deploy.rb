# config valid for current version and patch releases of Capistrano
lock '~> 3.19.2'

set :application, 'qna'
set :repo_url, 'git@github.com:Zhabrikoff/qna.git'

set :branch, 'main'

set :pty, false
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :sidekiq_roles, :app
set :init_system, :systemd
set :service_unit_name, 'sidekiq'

set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key', 'config/sidekiq.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'vendor', 'storage'

set :default_env, { 'NODE_OPTIONS' => '--openssl-legacy-provider' }
