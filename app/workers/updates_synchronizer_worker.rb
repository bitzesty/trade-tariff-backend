class UpdatesSynchronizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform
    logger.info "Running UpdatesSynchronizerWorker"
    logger.info "Downloading..."
    TariffSynchronizer.download
    logger.info "Applying..."
    TariffSynchronizer.apply
  end
end
