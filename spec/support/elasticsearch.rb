RSpec.configure do |config|
  config.before(:suite) do
    TradeTariffBackend.search_client.reindex
  end
end
