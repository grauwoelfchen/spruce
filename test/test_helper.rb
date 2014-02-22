helper = lambda {
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rails/test_help"
  require "mocha/mini_test"
  require "database_cleaner"

  # additional directories
  Dir[Rails.root.join("test/services/**/*.rb")].each { |f| require f }

  module MiniTest
    class Unit
      def startup;  end
      def shutdown; end

      alias_method :_run_suite_without_filters, :_run_suite
      def _run_suite(suite, type)
        begin
          suite.startup  if suite.respond_to?(:startup)
          _run_suite_without_filters(suite, type)
        ensure
          suite.shutdown if suite.respond_to?(:shutdown)
        end
      end

      alias_method :_run_suites_without_filters, :_run_suites
      def _run_suites(suites, type)
        begin
          startup
          _run_suites_without_filters(suites, type)
        ensure
          shutdown
        end
      end
    end
  end

  module MiniTest
    class Unit
      def startup
        ENV["FLOCK_DIR"] = Dir.mktmpdir
      end

      def shutdown
        FileUtils.remove_entry_secure(ENV["FLOCK_DIR"], true)
      end
    end
  end

  #MiniTest::Unit.runner = FilteredMiniTest::Unit.new
  #Minitest.after_run { puts ":-D" }

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
