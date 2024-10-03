source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sqlite3", ">= 1.4"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "bcrypt"
gem "jwt"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development do
  gem "annotate"
  gem "web-console"
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
