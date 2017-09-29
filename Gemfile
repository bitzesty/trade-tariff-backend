source "https://rubygems.org"
ruby "2.3.3"

gem "rails", "4.2.8"

gem "aws-sdk", "~> 2"
gem "aws-sdk-rails", ">= 1.0.1"
gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "pg"
gem "sequel-rails", "~> 0.9", ">= 0.9.12"
gem "tilt"
gem "rabl", "~> 0.12"
gem "ansi", "~> 1.5"
gem "sequel", "~> 4.32"
gem "sidekiq", "~> 4.1.1"
gem "sidekiq-scheduler", "~> 2.0"
gem "elasticsearch", "5.0.4"
gem "elasticsearch-extensions", "0.0.26"
gem "yajl-ruby", "~> 1.2", require: "yajl"
gem "builder", "~> 3.2"
gem "plek", "~> 1.11"
gem "gds-sso", "~> 12", ">= 12.1.0"
gem "ox", "~> 2.3"
gem "puma", "~> 3.4"
gem "curb", "~> 0.8"
gem "dalli", "~> 2.7"
gem "connection_pool", "~> 2.2"
gem "nokogiri", "~> 1.8.1"
gem "responders", "~> 2.1", ">= 2.1.0"
gem 'holidays'

gem "newrelic_rpm"
gem "logstash-event"
gem "lograge", ">= 0.3.6"
gem "rack-timeout", "~> 0.4"
gem "bootscale", "~> 0.5", require: false

group :production do
  gem "rails_12factor"
  gem "sentry-raven"
end

group :development, :test do
  gem "dotenv-rails", ">= 2.1.1"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "rspec-rails", "~> 3.5.2"
  gem "factory_girl_rails", "~> 4.8.0", require: false
  gem "fakefs", "~> 0.11.0", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions", "~> 0.9.0"
  gem "simplecov", "~> 0.14.1"
  gem "simplecov-rcov"
  gem "webmock", "~> 3.0.1"
  gem "database_cleaner", github: "theharq/database_cleaner", branch: "sequel-updates"
  gem "rspec_junit_formatter"
end
