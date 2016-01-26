source "https://rubygems.org"

gem "rails", "4.2.5.1"

gem "addressable", "~> 2.3"
gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "mysql2", "~> 0.3"
gem "sequel-rails", "~> 0.9"
gem "rabl", "~> 0.11"
gem "ansi", "~> 1.5"
gem "sequel", "~> 4.3.0"
gem "sidekiq", "~> 3.4.2"
gem "elasticsearch", "~> 0.4"
gem "elasticsearch-extensions", "~> 0.0"
gem "yajl-ruby", "~> 1.2", require: "yajl"
gem "dalli", "~> 2.7"
gem "builder", "~> 3.2"
gem "plek", "~> 1.11"
gem "gds-sso", "~> 11.0"

gem "unicorn", "~> 4.9"
gem "curb", "~> 0.8"

gem "nokogiri", "~> 1.6"

gem "whenever", "~> 0.9"
gem "airbrake", "~> 4.3"
gem "aws-ses", "~> 0.6", require: "aws/ses" #used for sync emails
gem "logstasher", "~> 0.6"
gem "responders", "~> 2.1"

gem "sass", "~> 3.4"
gem "sass-rails", "~> 5.0"
gem "therubyracer", "~> 0.12"
gem "uglifier", "~> 2.7"

group :development do
  gem "capistrano", "~> 3.4"
  gem "guard-rspec", "~> 4.6"
  gem "newrelic_rpm", "~> 3.12"
end

group :development, :test do
  gem "pry-rails", "~> 0.3"
  gem "pry-nav"
  gem "brakeman", "~> 3.0", require: false
end

group :test do
  gem "test-unit", "~> 3.1"
  gem "ci_reporter_rspec"
  gem "factory_girl_rails"
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "minitest", "~> 5.5"
  gem "rspec-rails", "~> 3.3"
  gem "shoulda-matchers", "~> 2.8"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "database_cleaner"
  gem "rspec_junit_formatter"
end
