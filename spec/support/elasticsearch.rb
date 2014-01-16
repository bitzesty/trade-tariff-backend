RSpec.configure do |config|
  config.before(:suite) do
    unless config.exclusion_filter[:elasticsearch]
      Elasticsearch::Extensions::Test::Cluster.start \
        cluster_name: "#{Rails.application.class.parent_name}-testing-cluster",
        nodes:        1,
        port:         9350
    end
  end

  config.after(:suite) do
    unless config.exclusion_filter[:elasticsearch]
      Elasticsearch::Extensions::Test::Cluster.stop \
        port:         9350
    end
  end
end
