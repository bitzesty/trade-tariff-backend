source 'https://rubygems.org'

gem 'rails', '~> 3.1.1'

gem 'bson'
gem 'bson_ext'
gem 'mongoid', "3.0.0.rc"
gem 'rabl'
gem 'yajl-ruby'
gem 'tire'
gem 'kaminari'

gem 'jquery-rails', "~> 1.0.19"
gem 'builder'
gem 'railties'

group :passenger_compatibility do
  gem 'rack', '1.3.5'
  gem 'rake', '0.9.2'
end

# #### Scraper
# gem 'sidekiq', git: "git://github.com/mperham/sidekiq.git"
# gem 'sinatra', '1.3.1'
# gem 'sprockets'
# gem 'slim'
# ####


group :assets do
  gem 'therubyracer'
  ### API Docs
  gem 'sass-rails', '~> 3.1.4'
  gem 'bootstrap-sass', '~> 2.0.3'
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
  # gem 'nokogiri'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
  # gem 'database_cleaner' # use me when mongoid 3.0 patch gets merged in
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
