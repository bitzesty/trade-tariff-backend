class RecacheModelsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: false

  def perform
    logger.info 'Running RecacheModelsWorker'
    logger.info 'Recache it up...'
    TradeTariffBackend.recache
    Rails.cache.clear
    TradeTariffBackend.pre_warm_headings_cache
    logger.info 'Recache complete!'
  end
end
