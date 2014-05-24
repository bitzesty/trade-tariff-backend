class RollbackWorker
  include Sidekiq::Worker

  sidekiq_options queue: :rollbacks, retry: false, backtrace: true

  def perform(date, redownload = false)
    TariffSynchronizer.rollback(date, redownload)
  end
end
