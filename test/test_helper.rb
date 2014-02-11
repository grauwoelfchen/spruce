helper = lambda {
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rails/test_help"
  require "database_cleaner"

  class ActiveSupport::TestCase
    ActiveRecord::Migration.check_pending!
    include Sorcery::TestHelpers::Rails

    DatabaseCleaner.strategy = :transaction
    #fixtures :all

    def setup
      ENV["FLOCK_DIR"] = Dir.mktmpdir
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
      FileUtils.remove_entry_secure ENV["FLOCK_DIR"]
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
