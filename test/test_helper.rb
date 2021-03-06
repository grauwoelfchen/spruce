helper = Proc.new do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rails/test_help"
  require "minitest/mock"
  require "minitest/rails/capybara"
  require "minitest/pride" if ENV["TEST_PRIDE"].present?
  require "database_cleaner"

  Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

  Capybara.app_host = "http://example.org"

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
end

unless defined?(Spork) && Spork.using_spork?
  helper.call
else
  Spork.prefork do
    helper.call
  end

  Spork.each_run do
  end
end
