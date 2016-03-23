ENV["RAILS_ENV"] ||= 'test'

require "spec_helper"

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'simplecov'
require 'simplecov-rcov'
require 'database_cleaner'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

require File.expand_path("../../config/environment", __FILE__)

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
  config.use_transactional_fixtures = false
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
  config.order = "random"
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.alias_it_should_behave_like_to :it_results_in, "it results in"
  config.alias_it_should_behave_like_to :it_is_associated, "it is associated"
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/
  config.include ControllerSpecHelper, type: :controller
  config.include SynchronizerHelper
  config.include LoggerHelper
  config.include RescueHelper
  config.include ChiefDataHelper
  config.include ActiveSupport::Testing::TimeHelpers

  config.include FactoryGirl::Syntax::Methods

  redis = Redis.new(:db => 15)
  RedisLockDb.redis = redis

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    redis.flushdb
  end

  config.after(:suite) do
    redis.flushdb
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
end
