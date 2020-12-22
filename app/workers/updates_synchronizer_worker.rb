class UpdatesSynchronizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform
    logger.info "Running UpdatesSynchronizerWorker"
    logger.info "Downloading..."

    # TODO: this check can be removed when we switch to CDS data.
    if PaasConfig.space.to_s == 'cds-test'
      TariffSynchronizer.download_cds
      logger.info "Applying..."
      TariffSynchronizer.apply_cds
    else
      # TODO: this can be removed when we switch to CDS data because we don't need to run CHIEF and TARIC updates.
      TariffSynchronizer.download
      logger.info "Applying..."
      TariffSynchronizer.apply
    end
  end
end
