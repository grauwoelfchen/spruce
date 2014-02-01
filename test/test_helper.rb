ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "database_cleaner"

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  DatabaseCleaner.strategy = :transaction
  #fixtures :all

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
