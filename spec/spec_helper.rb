ENV["RAILS_ENV"] ||= 'test'

require 'webmock/rspec'
WebMock.allow_net_connect!

require 'simplecov'
require 'simplecov-rcov'
require 'database_cleaner'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/autorun'
require 'rspec/rails'
require 'json_expressions/rspec'
require 'fakefs/spec_helpers'
require 'sidekiq/testing'
require 'elasticsearch/extensions/test/cluster'

require Rails.root.join("spec/support/tariff_validation_matcher.rb")
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# require models and serializers
Dir[Rails.root.join("app/models/*.rb")].each {|f| require f}
Dir[Rails.root.join("app/serializers/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.alias_it_should_behave_like_to :it_results_in, "it results in"
  config.alias_it_should_behave_like_to :it_is_associated, "it is associated"
  config.include RSpec::Rails::RequestExampleGroup, type: :request, example_group: { file_path: /spec\/api/ }
  config.include ControllerSpecHelper, type: :controller
  config.include SynchronizerHelper
  config.include RescueHelper
  config.include ChiefDataHelper

  config.include FactoryGirl::Syntax::Methods

  Redis::Classy.db = Redis.new(:db => 15)

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Redis::Classy.flushdb
  end

  config.after(:suite) do
    Redis::Classy.flushdb
    Redis::Classy.quit
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :truncation => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, :webmock) do
    WebMock.disable_net_connect!
  end

  config.after(:each, :webmock) do
    WebMock.allow_net_connect!
  end
end
