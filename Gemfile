source "https://rubygems.org"
source "https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/"

gem "rails", "3.2.17"

gem "addressable", "2.3.2"
gem "hashie", "2.0.5"
gem "multi_json", "~> 1.7.7"
gem "mysql2", "0.3.13"
gem "sequel-rails", "0.7.0"
gem "rabl", "0.9.0"
gem "mlanett-redis-lock", "0.2.5", require: 'redis-lock'
gem "ansi"
gem "sequel", "4.3.0"
gem "sidekiq", "2.17.2"
gem "elasticsearch", "0.4.7"
gem "elasticsearch-extensions", "0.0.12"
gem "yajl-ruby", "1.2.0", require: "yajl"
gem "strong_parameters"

gem "builder"
gem "jquery-rails", "1.0.19"
gem "plek", "1.0.0"
gem 'gds-sso', '3.1.0'
gem "railties"

gem "unicorn", "~> 4.6.3"
gem "curb", "0.8.3"

gem "nokogiri", "1.5.4"

gem "whenever", "~> 0.9.2"
gem "airbrake", "3.1.16"
gem "aws-ses", require: "aws/ses" #used for sync emails
gem "logstasher", "0.4.8"

group :assets do
  gem "bootstrap-sass"
  gem "sass-rails"
  gem "therubyracer", "0.12.0"
  gem "uglifier"
end

group :development do
  gem "capistrano"
  gem "guard-rspec"
  gem "newrelic_rpm"
end

group :development, :test do
  gem "pry-rails"
end

group :test do
  gem "brakeman", "1.7.0"
  gem "ci_reporter"
  gem "factory_girl_rails"
  gem "fakefs", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions"
  gem "rspec-rails", "~> 2.14.0"
  gem "shoulda-matchers", "~> 2.0.0"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
end

group :router do
  gem "router-client", "3.0.1", :require => "router"
end
