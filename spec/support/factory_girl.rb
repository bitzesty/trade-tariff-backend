require 'factory_girl_rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#custom-methods-to-persist-objects
  to_create { |instance| instance.save }
end
