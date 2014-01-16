require 'sidekiq/testing'

Sidekiq::Logging.logger = nil

RSpec.configure do |config|
  config.before(:each) do |example_method|
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all
    # Get the current example from the example_method object
    example = example_method.example

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif example.metadata[:type] == :acceptance || example.metadata[:sidekiq] == :integration
      Sidekiq::Testing.disable!
    else
      Sidekiq::Testing.fake!
    end
  end
end
