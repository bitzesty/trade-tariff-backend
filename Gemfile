source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.1"

gem "rails", "5.1.3"


gem "pg", "0.18.4"
gem "sequel", "~> 4.32"
gem "sequel-rails", "~> 0.9", ">= 0.9.12"


gem "puma", "~> 3.4"


gem "aws-sdk", "~> 2"
gem "aws-sdk-rails", ">= 1.0.1"


gem "hashie", "~> 3.4"
gem "multi_json", "~> 1.11"
gem "yajl-ruby", "~> 1.3.1", require: "yajl"
gem "builder", "~> 3.2"
gem "ox", ">= 2.8.1"
gem "nokogiri", "~> 1.8.1"


gem "tilt"
gem "rabl", "~> 0.12"
gem "ansi", "~> 1.5"
gem "responders", "~> 2.1", ">= 2.1.0"


gem "sidekiq", "~> 4.1.4"
gem "sidekiq-scheduler", "~> 2.1.8"


gem "elasticsearch", "5.0.4"
gem "elasticsearch-extensions", "0.0.26"


gem "plek", "~> 1.11"
gem "gds-sso", "~> 13", ">= 12.1.0"

gem "curb", "~> 0.8"
gem "dalli", "~> 2.7"
gem "connection_pool", "~> 2.2"


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

group :development do
  gem "foreman"
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
  gem "forgery", github: "mtunjic/forgery", branch: "master"
  gem "json_expressions", "~> 0.9.0"
  gem "simplecov", "~> 0.14.1"
  gem "simplecov-rcov"
  gem "webmock", "~> 3.0.1"
  gem "database_cleaner", github: "theharq/database_cleaner", branch: "sequel-updates"
  gem "rspec_junit_formatter"
end
