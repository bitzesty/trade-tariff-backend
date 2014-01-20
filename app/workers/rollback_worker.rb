class RollbackWorker
  include Sidekiq::Worker

  sidekiq_options queue: :rollbacks

  def perform(date, redownload = false)
    TariffSynchronizer.rollback(date, redownload)
  end
end
