source "https://rubygems.org"
source "https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/"

gem "rails", "3.2.14"

gem "addressable", "2.3.2"
gem "multi_json", "~> 1.7.7"
gem "mysql2"
gem "sequel-rails", "~> 0.5.0"
gem "rabl", "0.7.6"
gem "ansi"
gem "sequel", "4.0.0"
gem "tire", "0.6.0"
gem "tire-contrib", '~> 0.1.3'
gem "yajl-ruby", require: "yajl"
gem "strong_parameters"

gem "builder"
gem "jquery-rails", "1.0.19"
gem "plek", "1.0.0"
gem 'gds-sso', '3.0.0'
gem "railties"

gem "unicorn", "~> 4.6.3"
gem "curb", "0.8.3"

gem "nokogiri", "1.5.4"

gem "whenever", "0.7.3"
gem "aws-ses", require: "aws/ses" # Needed by exception_notification
gem "exception_notification"

group :assets do
  gem "bootstrap-sass"
  gem "sass-rails"
  gem "therubyracer"
  gem "uglifier"
end

group :development do
  gem "capistrano"
  gem "guard-rspec"
end

group :development, :test do
  gem "pry-rails"
end

group :test do
  gem "brakeman", "1.7.0"
  gem "ci_reporter"
  gem "factory_girl_rails"
  gem "forgery"
  gem "json_expressions"
  gem "rspec-rails", "~> 2.14.0"
  gem "shoulda-matchers", "~> 2.0.0"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "vcr"
end

group :router do
  gem "router-client", "3.0.1", :require => "router"
end
