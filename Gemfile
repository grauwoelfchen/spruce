source "https://rubygems.org"

gem "foreman"
gem "rails", "4.0.2"

gem "sorcery"
gem "closure_tree"
gem "delayed_job_active_record"

gem "turbolinks"
gem 'uglifier', '>= 1.3.0'
gem "slim"
gem "stylus", :github => "grauwoelfchen/ruby-stylus", :branch => "prevent-exception-by-no-ext-logical-path-for-sprockets"

group :development, :test do
  gem "sqlite3"
end

group :development do
  gem "slim-rails", "~> 2.0.4"
end

group :test do
  gem "mocha"
  gem "database_cleaner"
end

group :production do
  gem "unicorn"
  gem "pg"
end

personal = File.expand_path("../Gemfile.personal", __FILE__)
eval File.read(personal) if File.exists?(personal)
