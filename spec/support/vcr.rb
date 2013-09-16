require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = Rails.root.join('spec', 'vcr')
  # c.ignore_hosts Tire::Configuration.url
  # c.ignore_localhost = true
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
