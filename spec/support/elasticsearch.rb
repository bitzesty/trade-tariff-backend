RSpec.configure do |config|
  config.before(:suite) do
    Elasticsearch::Extensions::Test::Cluster.start \
      cluster_name: TradeTariffBackend.search_namespace,
      nodes:        1,
      port:         TradeTariffBackend.search_port

    TradeTariffBackend.search_client.reindex
  end

  config.after(:suite) do
    Elasticsearch::Extensions::Test::Cluster.stop \
      port:         TradeTariffBackend.search_port
  end
end
