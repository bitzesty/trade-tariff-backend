source "https://rubygems.org"
source "https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/"

gem "rails", "3.2.13"

gem "addressable", "2.3.2"
gem "mysql2"
gem "multi_json"
gem "yajl-ruby", require: "yajl"
gem "rabl", "0.7.6"
gem "sequel"
gem "nulogy-sequel-rails", "0.3.9"
gem "tire", "0.6.0"
gem "tire-contrib", github: "karmi/tire-contrib",  require: 'tire/namespace'

gem "builder"
gem "jquery-rails", "1.0.19"
gem "plek", "1.0.0"
gem "railties"

gem "unicorn", "4.3.1"
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
  gem "rspec-rails"
  gem "shoulda-matchers", '>= 1.5.1'
  gem "mocha", ">= 0.13.3"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "vcr"
end

group :router do
  gem "router-client", "3.0.1", :require => "router"
end
