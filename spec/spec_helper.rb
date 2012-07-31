require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# for FactoryGirl and Sequel compatibility
class Sequel::Model
  def save!
    save(:validate=>false)
  end
end

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include RSpec::Rails::RequestExampleGroup, type: :request, example_group: { file_path: /spec\/api/ }
  config.mock_with :mocha

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:any, %r|\Ahttp://localhost:9200|, :body => "{}")

    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
