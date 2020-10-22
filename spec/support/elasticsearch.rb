RSpec.configure do |config|
  config.before(:suite) do
    TradeTariffBackend.search_client.reindex
    TradeTariffBackend.cache_client.reindex
  end
end
