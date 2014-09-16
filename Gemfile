source "https://rubygems.org"

gem "rails", "~> 4.1.6"

gem "addressable", "2.3.2"
gem "hashie", "2.0.5"
gem "multi_json", "~> 1.7"
gem "mysql2", "0.3.13"
gem "sequel-rails", "0.7.0"
gem "rabl", "0.10.0"
gem "redis-mutex", "2.1.1"
gem "ansi"
gem "sequel", "4.3.0"
gem "sidekiq", "2.17.2"
gem "elasticsearch", "0.4.7"
gem "elasticsearch-extensions", "0.0.12"
gem "yajl-ruby", "1.2.0", require: "yajl"
gem "dalli", "2.7.2"
gem "builder"
gem "plek", "~> 1.8"
gem 'gds-sso', '9.3.0'
gem "railties"

gem "unicorn", "~> 4.6.3"
gem "curb", "0.8.3"

gem "nokogiri", "1.5.4"

gem "whenever", "~> 0.9.2"
gem "sentry-raven", git: "https://github.com/getsentry/raven-ruby.git"
gem "aws-ses", require: "aws/ses" #used for sync emails
gem "logstasher", "0.4.8"
gem "foreman"

gem "sass-rails", "~> 4.0.3"
gem "therubyracer", "0.12.0"
gem "uglifier", "~> 2.5.3"

group :development do
  gem "capistrano"
  gem "guard-rspec"
  gem "newrelic_rpm"
end

group :development, :test do
  gem "pry-rails"
  gem "pry-nav"
end

group :test do
  gem "brakeman", "1.7.0"
  gem "ci_reporter_rspec"
  gem "factory_girl_rails"
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "minitest", "~> 5.4.2"
  gem "rspec-rails", "~> 2.14.0"
  gem "shoulda-matchers", "~> 2.0.0"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "database_cleaner"
end
