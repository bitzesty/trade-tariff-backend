class UpdatesSynchronizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform
    logger.info "Running UpdatesSynchronizerWorker"
    TariffSynchronizer.download
    TariffSynchronizer.apply
  end
end
