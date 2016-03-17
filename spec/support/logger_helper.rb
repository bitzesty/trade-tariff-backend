require 'active_support/log_subscriber/test_helper'

module LoggerHelper
  include ActiveSupport::LogSubscriber::TestHelper

  def tariff_importer_logger_listener
    setup # Setup LogSubscriber::TestHelper
    TariffImporter::Logger.attach_to :tariff_importer
    TariffImporter::Logger.logger = @logger
  end

  def tariff_synchronizer_logger_listener
    setup # Setup LogSubscriber::TestHelper
    allow_any_instance_of(TariffSynchronizer::Logger).to receive(:logger).and_return(@logger)
    TariffSynchronizer::Logger.attach_to :tariff_synchronizer
  end

  def chief_transformer_logger_listener
    setup # Setup LogSubscriber::TestHelper
    ChiefTransformer::Logger.attach_to :chief_transformer
    ChiefTransformer::Logger.logger = @logger
  end
end
