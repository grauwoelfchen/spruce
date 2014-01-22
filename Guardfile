group :default do
  guard :spork \
    , :cucumber_env => { "RAILS_ENV" => "test" },
      :rspec_env    => { "RAILS_ENV" => "test" },
      :rspec_port   => "5001",
      :test_unit    => false do
    watch("config/application.rb")
    watch("config/environment.rb")
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch("Gemfile")
    watch("Gemfile.lock")
    watch("spec/spec_helper.rb") { :rspec }
    watch("test/test_helper.rb") { :test_unit }
    watch(%r{features/support/}) { :cucumber }
  end
end

group :specs do
  opts = {
    :cmd            => "rspec --drb --drb-port 5001 --color",
    :all_on_start   => false,
    :all_after_pass => true,
    :failed_mode    => :none,
    :launchy        => nil,
    :notification   => true,
    :spec_paths     => ["spec"],
    :run_all        => {},
  }
  guard :rspec, opts do
    watch(%r{^spec/factories/(.+)\.rb$})
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})    { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch("spec/spec_helper.rb") { "spec" }
    # Rails
    #watch(%r{^app/(.+)\.rb$})                          { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^spec/support/(.+)\.rb$})                 { "spec" }
    watch("config/routes.rb")                          { "spec/routing" }
    watch("app/controllers/application_controller.rb") { "spec/controllers" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
      [
        "spec/routing/#{m[1]}_routing_spec.rb",
        "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
        "spec/features/#{m[1]}_spec.rb"
      ]
    end
    watch(%r{app/models/concerns/(.+)\.rb$})           { "spec/models" }
    watch(%r{app/authorizers/concerns/(.+)\.rb$})      { "spec/authorizers" }
    # Capybara and views
    watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) do |m|
      [
        "spec/views/#{m[1]}_spec.rb",
        "spec/features/#{m[1]}_spec.rb"
      ]
    end
    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})  { |m| Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance" }
  end
end

$stdout.sync = true
notification :stumpish, :priority => 0 if defined?(Notifier::Stumpish)
