if Rails.env.production?
  Tire.configure do
    url "http://support.cluster:9200"
    index "tariff"
  end
elsif Rails.env.development?
  Tire.configure do
    url "http://localhost:9200"
    index "tariff-development"
  end
else
  Tire.configure do
    url "http://localhost:9200"
    index "tariff-test"
  end
end
