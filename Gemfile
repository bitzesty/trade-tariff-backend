source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.6.5"

# Server
gem "puma", "~> 3.12"
gem "rails", "6.0.2.1"
gem "sinatra", "~> 2.0.2"

# DB
gem 'pg', "~> 1.1", ">= 1.1.3"
gem "sequel", "~> 5.16.0"
gem "sequel-rails", "~> 1.0.0"

# File uploads and AWS
gem "aws-sdk", "~> 2"
gem "aws-sdk-rails", ">= 1.0.1"

# File zip/unzipping
gem "rubyzip", ">= 1.3.0"

# Background jobs
gem "redis-rails"
gem "sidekiq", "<6"
gem "sidekiq-scheduler", "~> 2.2.2"
gem "redlock", "~> 1.0.1"

# Elasticsearch
gem "elasticsearch", "6.1.0"
gem "elasticsearch-extensions", "0.0.30"

# Helpers
gem "bootsnap", require: false
gem "builder", "~> 3.2"
gem "gds-sso", "~> 13", ">= 12.1.0"
gem "hashie", "~> 3.4"
gem "holidays"
gem "lograge", ">= 0.3.6"
gem "logstash-event"
gem "multi_json", "~> 1.11"
gem "scout_apm"
gem "nokogiri", ">= 1.10.5"
gem "ox", ">= 2.8.1"
gem "plek", "~> 1.11"
gem "rack-timeout", "~> 0.4"
gem "sentry-raven"
gem "yajl-ruby", "~> 1.3.1", require: "yajl"

# API related
gem "ansi", "~> 1.5"
gem "curb", "~> 0.9"
gem "fast_jsonapi", "~> 1.5"
gem "rabl", "~> 0.14"
gem "responders", "~> 3.0.0"
gem "tilt"

# Printed PDF
gem 'uktt', git: 'https://gitlab.bitzesty.com/open-source/uktt.git', branch: :master
gem 'combine_pdf'
gem 'sidekiq-batch'

group :production do
  gem "rails_12factor"
end

group :development do
  gem "foreman"
  gem "govuk-lint"
  gem "letter_opener"
end

group :development, :test do
  gem "dotenv-rails", ">= 2.1.1"
  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 4.8.0", require: false
  gem "fakefs", "~> 0.18.0", require: "fakefs/safe"
  gem "forgery"
  gem "json_expressions", "~> 0.9.0"
  gem "rspec-rails", "~> 3.5.2"
  gem "rspec_junit_formatter"
  gem "simplecov", "~> 0.15.0", require: false
  gem "webmock", "~> 3.5.0"
end
