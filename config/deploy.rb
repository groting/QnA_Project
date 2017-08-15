# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "qna"
set :repo_url, "git@github.com:groting/QnA_Project.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/ubuntu/qna"
set :deploy_user, "ubuntu"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end