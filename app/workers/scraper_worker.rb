require 'scrape'
class ScraperWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def perform(code, type)
    Scrape::Persistance.process(code, type)
  end
end
