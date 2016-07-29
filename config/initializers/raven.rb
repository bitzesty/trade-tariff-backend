if defined?(Raven)
  tags = JSON.parse(ENV["VCAP_APPLICATION"])
             .except('application_uris', 'host', 'application_name', 'space_id', 'port', 'uris', 'application_version')
             .merge({ server_name: ENV["GOVUK_APP_DOMAIN"] })
  Raven.configure do |config|
    config.tags = tags
  end
end
