class UpdatesSynchronizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform
    logger.info "Running UpdatesSynchronizerWorker"
    logger.info "Downloading..."

    if PaasConfig.space.to_s == 'cds-test'
      TariffSynchronizer.download_cds
      logger.info "Applying..."
      TariffSynchronizer.apply_cds
    else
      TariffSynchronizer.download
      logger.info "Applying..."
      TariffSynchronizer.apply
    end
  end
end
