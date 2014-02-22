# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require "rake/testtask"
require File.expand_path('../config/application', __FILE__)

Spruce::Application.load_tasks

# assets
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

# test
#namespace :test do
#  desc "Test services"
#  Rake::TestTask.new(:services => "test") do |t|
#    t.libs << "test"
#    t.pattern = "test/services/**/*_test.rb"
#    t.verbose = true
#  end
#end
#Rake::Task[:test].enhance { Rake::Task["test:services"].invoke }
