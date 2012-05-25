Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'uktt' }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'uktt', :size => 1 }
end
