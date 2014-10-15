# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require "rake/testtask"
require File.expand_path("../config/application", __FILE__)

Spruce::Application.load_tasks

namespace :test do
  desc "Run tests for services"
  Rake::TestTask.new(:services => "environment") do |t|
    t.libs << "test"
    t.pattern = "test/services/**/*_test.rb"
  end

  desc "Run test for routes"
  Rake::TestTask.new(:routes => "environment") do |t|
    t.libs << "test"
    t.pattern = "test/integration/routes_test.rb"
  end
end
