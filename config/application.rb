require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TradeTariffBackend
  class Application < Rails::Application
    require 'trade_tariff_backend'

    # lib directory to be autoloadable.
    config.autoload_paths << "#{Rails.root}/lib"

    config.generators do |g|
      g.view_specs     false
      g.helper_specs   false
      g.test_framework false
    end

    config.time_zone = 'UTC'

    # Enable the asset pipeline
    config.assets.enabled = false

    # Configure sequel
    config.sequel.schema_format = :sql
    config.sequel.default_timezone = :utc

    config.sequel.after_connect = proc do
      Sequel::Model.plugin :take
      Sequel::Model.plugin :validation_class_methods

      Sequel::Model.db.extension :pagination
      Sequel::Model.db.extension :server_block
    end
  end
end
