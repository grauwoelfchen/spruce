source "https://rubygems.org"

gem "foreman"
gem "dotenv-rails", "~> 0.11.1"

gem "rails", "~> 4.1.8"

gem "pg"

gem "sorcery"
gem "closure_tree"
gem "delayed_job_active_record"
gem "paper_trail", "~> 3.0.1"

gem "turbolinks"
gem "uglifier"
gem "slim"
gem "stylus"

group :development do
  gem "slim-rails"
  gem "capistrano", "~> 3.2.0"
  gem "capistrano-rails"
end

group :test do
  gem "minitest", "~> 5.4"
  gem "minitest-rails-capybara"
  gem "mocha"
  gem "database_cleaner"
  gem "test_after_commit"
end

group :production do
  gem "unicorn"
  gem "unicorn-worker-killer"
  gem "newrelic_rpm"
end

personal = File.expand_path("../Gemfile.personal", __FILE__)
eval File.read(personal) if File.exists?(personal)
