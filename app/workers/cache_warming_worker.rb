class CacheWarmingWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: false

  def perform
    logger.info 'Running CacheWarmingWorker'
    logger.info 'Warming it up...'
    TradeTariffBackend.pre_warm_headings_cache
    logger.info 'Warming complete!'
  end
end
