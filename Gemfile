source 'https://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.8'

gem 'mysql2'
gem 'oj'
gem 'rabl'
gem 'sequel'
gem 'talentbox-sequel-rails', git: "git://github.com/alphagov/sequel-rails.git", branch: 'production'
gem 'tire'

gem 'builder'
gem 'jquery-rails', "~> 1.0.19"
gem 'railties'

gem 'airbrake'
gem 'unicorn', '~> 4.3.1'
gem 'curb'

gem 'whenever'

gem 'tariff_importer', '~> 0.0.5'

gem 'pry-rails'

group :assets do
  gem 'bootstrap-sass'
  gem 'sass-rails'
  gem 'therubyracer'
  gem 'uglifier'
end

group :development do
  gem 'capistrano'
  gem 'guard-rspec'
end

group :test do
  gem 'brakeman', '~> 1.7.0'
  gem 'ci_reporter'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'json_expressions'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock'
  gem 'vcr'
  gem 'mocha', require: false
end

group :router do
  gem 'router-client', '~> 3.0.1', :require => 'router'
end
