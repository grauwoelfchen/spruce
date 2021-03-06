app_path = "/var/www/spruce"
app_shared_path = "#{app_path}/shared"

worker_processes 2
timeout 15

preload_app true

working_directory "#{app_path}/current/"

listen "#{app_shared_path}/tmp/sockets/unicorn.spruce.sock"

stdout_path "#{app_shared_path}/log/unicorn.stdout.log"
stderr_path "#{app_shared_path}/log/unicorn.stderr.log"

pid "#{app_shared_path}/tmp/pids/unicorn.pid"
