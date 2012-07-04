source 'https://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.6'

gem 'mysql2'
gem 'composite_primary_keys'

gem 'rabl'
gem 'yajl-ruby', require: "yajl/json_gem"
gem 'tire', git: 'https://github.com/sauliusg/tire', branch: 'custom_query_pagination'
# gem 'tire-contrib'
gem 'kaminari'

gem 'jquery-rails', "~> 1.0.19"
gem 'builder'
gem 'railties'

gem 'airbrake'

# group :passenger_compatibility do
#   gem 'rack', '1.3.5'
#   gem 'rake', '0.9.2'
# end

group :assets do
  gem 'therubyracer'
  ### API Docs
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'uglifier'
  ##
end

group :development do
  gem 'puma'
  gem 'capistrano'
  gem 'debugger'
  gem 'pry-rails'
  gem 'spreadsheet'
  gem 'progressbar'
  gem 'awesome_print'
  gem 'rails-erd'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'shoulda-matchers'
  gem 'fakeweb'
  gem 'mocha'
  gem 'pathy'
  # TODO upgrade to mongoid-rspec 1.4.5 when it's released
  # gem 'mongoid-rspec', git: 'https://github.com/evansagge/mongoid-rspec.git'

  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
end

group :router do
  gem 'router-client', '~> 3.0.1', :require => 'router'
end
