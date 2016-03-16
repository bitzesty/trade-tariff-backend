require 'active_support/log_subscriber/test_helper'

module LoggerHelper
  include ActiveSupport::LogSubscriber::TestHelper

  def tariff_importer_logger_listener
    setup # Setup LogSubscriber::TestHelper
    TariffImporter::Logger.attach_to :tariff_importer
    TariffImporter::Logger.logger = @logger
  end

  def chief_transformer_logger_listener
    setup # Setup LogSubscriber::TestHelper
    ChiefTransformer::Logger.attach_to :chief_transformer
    ChiefTransformer::Logger.logger = @logger
  end
end
