class RecacheModelsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: false

  def perform
    logger.info 'Running RecacheModelsWorker'
    logger.info 'Recache it up...'
    TradeTariffBackend.recache
    logger.info 'Recache complete!'
  end
end
