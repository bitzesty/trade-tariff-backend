require 'vcr'
require 'fakeweb'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'vcr')
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
end
