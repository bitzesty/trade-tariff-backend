source 'https://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rails', '3.2.5'

gem 'bson'
gem 'bson_ext'
gem 'mongoid', "3.0.0.rc"
gem 'rabl'
gem 'yajl-ruby', require: "yajl/json_gem"
gem 'tire'
gem 'kaminari'

gem 'jquery-rails', "~> 1.0.19"
gem 'builder'
gem 'railties'

gem 'airbrake'

group :assets do
  gem 'therubyracer'
  ### API Docs
  gem 'sass-rails',   '~> 3.2.5'
  gem 'bootstrap-sass'
  gem 'uglifier', '>= 1.0.3'
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
  gem 'mongoid-rspec', git: 'https://github.com/evansagge/mongoid-rspec.git'

  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
end

group :router do
  gem 'router-client', '~> 3.0.1', :require => 'router'
end
