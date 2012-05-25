require 'scrape'
class ScraperWorker
  include Sidekiq::Worker

  def perform(code, type)
    Scrape::Persistance.process(code, type)
  end
end
