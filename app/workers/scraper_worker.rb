# require 'scrape'
# class ScraperWorker
#   include Sidekiq::Worker

#   sidekiq_options :retry => false

#   def perform(arry)
#     code = arry[0]
#     type = arry[1]
#     Scrape::Persistance.process(code, type)
#   end
# end
