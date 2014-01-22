source "https://rubygems.org"

gem "foreman"
gem "rails", "4.0.2"

gem "turbolinks"
gem 'uglifier', '>= 1.3.0'
gem "haml"
gem "stylus"

group :development, :test do
  gem "sqlite3"
  gem "factory_girl_rails"
end

group :development do
  gem "haml-rails", "~> 0.5"
end

group :test do
end

group :production do
  gem "unicorn"
  gem "pg"
end

personal = File.expand_path("../Gemfile.personal", __FILE__)
eval File.read(personal) if File.exists?(personal)
