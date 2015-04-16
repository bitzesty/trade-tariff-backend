source "https://rubygems.org"

gem "rails", "4.2.0"

gem "addressable", "~> 2.3"
gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "mysql2", "~> 0.3"
gem "sequel-rails", "~> 0.9"
gem "rabl", "~> 0.11"
gem "ansi"
gem "sequel", "~> 4.3.0"
gem "sidekiq", "~> 2.17"
gem "elasticsearch", "~> 0.4"
gem "elasticsearch-extensions", "~> 0.0"
gem "yajl-ruby", "~> 1.2", require: "yajl"
gem "dalli", "~> 2.7.2"
gem "builder", "~> 3.2"
gem "plek", "~> 1.10"
gem "gds-sso", "~> 10.0"

gem "unicorn", "~> 4.8"
gem "curb", "0.8.6"

gem "nokogiri", "~> 1.6"

gem "whenever", "~> 0.9"
gem "airbrake", "~> 4.1"
gem "aws-ses", "~> 0.6", require: "aws/ses" #used for sync emails
gem "logstasher", "~> 0.6"

gem "sass-rails", "~> 5.0"
gem "therubyracer", "~> 0.12"
gem "uglifier", "~> 2.7"
gem "responders", "~> 2.0"

group :development do
  gem "capistrano", "~> 3.4"
  gem "guard-rspec"
  gem "newrelic_rpm"
end

group :development, :test do
  gem "pry-rails"
  gem "pry-nav"
  gem "bundler-audit"
  gem "brakeman", "~> 3.0", require: false
end

group :test do
  gem "test-unit", "~> 3.0"
  gem "ci_reporter_rspec"
  gem "factory_girl_rails"
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "minitest", "~> 5.5"
  gem "rspec-rails", "~> 2.14.2"
  gem "shoulda-matchers", "~> 2.8"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "database_cleaner"
end
