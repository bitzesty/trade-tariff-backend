source 'https://rubygems.org'

gem 'rails', '3.2.3'

gem 'bson'
gem 'bson_ext'
gem 'mongoid'
gem 'jbuilder'
gem 'tire'
gem 'kaminari'

gem 'jquery-rails'


#### Scraper
gem 'sidekiq', git: "git://github.com/mperham/sidekiq.git"
gem 'sinatra'
gem 'sprockets'
gem 'slim'
####

group :development do
  gem 'puma'
  gem 'capistrano'
  gem 'debugger'
  gem 'pry-rails'
  gem 'spreadsheet'
  gem 'progressbar'
  gem 'awesome_print'
  gem 'mechanize'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fakeweb'
  gem 'mocha'
  gem 'pathy'
  # TODO upgrade to mongoid-rspec 1.4.5 when it's released
  gem 'mongoid-rspec', git: 'https://github.com/evansagge/mongoid-rspec.git'

  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'ci_reporter'
end
