source "https://rubygems.org"
ruby "2.3.1"

gem "rails", "4.2.5.2"

gem "aws-sdk", "~> 2"
gem "aws-sdk-rails"
gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "pg"
gem "sequel-rails", "~> 0.9"
gem "rabl", "~> 0.11"
gem "ansi", "~> 1.5"
gem "sequel", "~> 4.32"
gem "sidekiq", "~> 4.1.1"
gem "sidekiq-scheduler", "~> 2.0"
gem "elasticsearch", "~> 1.0"
gem "elasticsearch-extensions", "~> 0.0"
gem "yajl-ruby", "~> 1.2", require: "yajl"
gem "builder", "~> 3.2"
gem "plek", "~> 1.11"
gem "gds-sso", "~> 11.0"
gem "ox", "~> 2.3"
gem "puma", "~> 3.4"
gem "curb", "~> 0.8"

gem "nokogiri", "~> 1.6"
gem "responders", "~> 2.1"

gem "sass", "~> 3.4"
gem "sass-rails", "~> 5.0"
gem "therubyracer", "~> 0.12"
gem "uglifier", "~> 2.7"
gem "newrelic_rpm"

group :production do
  gem "rails_12factor"
  gem "sentry-raven"
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "rspec-rails", "~> 3.0"
  gem "factory_girl_rails", require: false
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "database_cleaner", github: "theharq/database_cleaner", branch: "sequel-updates"
  gem "rspec_junit_formatter"
end
