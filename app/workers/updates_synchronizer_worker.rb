class UpdatesSynchronizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sync, retry: false

  def perform
    TariffSynchronizer.download
    TariffSynchronizer.apply
  end
end
