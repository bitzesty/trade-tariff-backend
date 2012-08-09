source 'https://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.7'

gem 'mysql2'
gem 'oj'
gem 'rabl'
gem 'tire'
gem 'sequel'
gem 'talentbox-sequel-rails', git: "git://github.com/alphagov/sequel-rails.git", branch: 'production'

gem 'jquery-rails', "~> 1.0.19"
gem 'builder'
gem 'railties'

gem 'airbrake'
gem 'unicorn', '~> 4.3.1'

group :assets do
  gem 'therubyracer'
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'uglifier'
end

group :development do
  gem 'capistrano'
end

group :development, :test do
  gem 'pry-rails'
end

group :test do
  gem 'brakeman', '~> 1.7.0'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'shoulda-matchers'
  gem 'fakeweb'
  gem 'vcr'
  gem 'mocha'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'json_expressions'
end

group :router do
  gem 'router-client', '~> 3.0.1', :require => 'router'
end
