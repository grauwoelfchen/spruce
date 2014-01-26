# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

namespace :components do
  desc "Add .txt to files which have no extension in 'components' for sprockets"
  # See https://github.com/sstephenson/sprockets/issues/347
  task :extension do
    Dir["vendor/assets/components/**/*"].each do |file|
      if File.file?(file) && File.extname(file).empty?
        File.rename(file, "#{file}.txt")
      end
    end
  end
end

Ash::Application.load_tasks
