if Rails.env.production?
  Tire.configure {url "http://support.cluster:9200"}
elsif Rails.env.development?
  Tire.configure {url "http://localhost:9200"}
else
  Tire.configure {url "http://localhost:9200"}
end
