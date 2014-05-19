class RollbackWorker
  include Sidekiq::Worker

  sidekiq_options queue: :rollbacks

  # Retry the job for 24 hours, after that the rollback has to be be recreated.
  sidekiq_options retry: 24

  # Retry the job every hour (the sync runs each hour)
  sidekiq_retry_in do |count|
    3600 
  end

  def perform(date, redownload = false)
    TariffSynchronizer.rollback(date, redownload)
  end
end
