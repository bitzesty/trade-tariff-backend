class UpdatesSynchronizerWorker
  include Sidekiq::Worker
  def perform
    TariffSynchronizer.download
    TariffSynchronizer.apply
  end
end
