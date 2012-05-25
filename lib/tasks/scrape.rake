require 'scrape'

namespace :scrape do
  desc "Import scraped data"
  task import: 'environment' do
    Scrape.import
  end
end
