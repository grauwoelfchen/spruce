helper = lambda {
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rails/test_help"
  require "mocha/mini_test"
  require "minitest/mock"
  require "minitest/rails/capybara"
  require "minitest/pride" if ENV["TEST_PRIDE"].present?
  require "database_cleaner"

  # additional directories as NOTE, (run test:all for these tests)
  #Dir[
  #  Rails.root.join("test/services/**/*.rb"),
  #  Rails.root.join("test/features/**/*.rb")
  #].each { |f| require f }

  class ActiveSupport::TestCase
    include Sorcery::TestHelpers::Rails

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
}

unless defined?(Spork) && Spork.using_spork?
  helper.call
else
  Spork.prefork do
    helper.call
  end

  Spork.each_run do
  end
end
