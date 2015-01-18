# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require "rake/testtask"
require File.expand_path("../config/application", __FILE__)

Spruce::Application.load_tasks

namespace :test do
  desc "Run service tests"
  Rake::TestTask.new(:services => "test:prepare") do |t|
    t.libs << "test"
    t.pattern = "test/services/**/*_test.rb"
  end

  desc "Run feature tests"
  Rake::TestTask.new(:features => "test:prepare") do |t|
    t.libs << "test"
    t.pattern = "test/features/**/*_test.rb"
  end
end

# Just run test:all
#Rake::Task["test:run"].enhance ["test:features"]
#Rake::Task["test:run"].enhance ["test:services"]
