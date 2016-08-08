class RollbackWorker
  include Sidekiq::Worker

  sidekiq_options queue: :rollbacks, retry: false

  def perform(date, redownload = false)
    TariffSynchronizer.rollback(date, redownload)
  end
end
