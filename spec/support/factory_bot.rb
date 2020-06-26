require_relative 'looping_sequence'
require 'factory_bot_rails'
require_relative 'database_cleaner'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#custom-methods-to-persist-objects
  to_create(&:save)
end
