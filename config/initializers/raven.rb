if defined?(Raven)
  Raven.configure do |config|
    config.tags = { server_name: ENV["GOVUK_APP_DOMAIN"] }
  end
end
