source "https://rubygems.org"
source "https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/"

gem "rails", "3.2.9"

gem "mysql2"
gem "multi_json"
gem "yajl-ruby", require: "yajl"
gem "rabl", "0.7.6"
gem "sequel"
gem "nulogy-sequel-rails", "0.3.9"
gem "tire"

gem "builder"
gem "jquery-rails", "1.0.19"
gem "plek", "0.5.0"
gem "railties"

gem "unicorn", "4.3.1"
gem "curb"

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
  gem "shoulda-matchers", git: "https://github.com/thoughtbot/shoulda-matchers.git",
                          ref: "9e1188eea6" # TODO change to stable version when next release comes out
  gem "mocha", require: false
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock"
  gem "vcr"
end

group :router do
  gem "router-client", "3.0.1", :require => "router"
end
