require 'spec_helper'
require 'date'
require 'tariff_synchronizer'
require 'tariff_synchronizer/download_service'

describe TariffSynchronizer::DownloadService do
  describe ".get_content", :webmock do
    let(:example_url) { "http://example.com/data" }
    let(:non_terminating_response_code) { 403 }
    let(:terminating_response_code)     { 200 }

    before do
      TariffSynchronizer.username = nil
      TariffSynchronizer.password = nil
      TariffSynchronizer.request_throttle = 0
    end

    it 'downloads content from remote url' do
      VCR.use_cassette('example_get_content') do
        TariffSynchronizer::DownloadService.get_content(example_url).should == "Hello world"
      end
    end

    it 'retries if does not receive a terminating http code' do
      TariffSynchronizer::DownloadService.stubs(:send_request)
                                     .returns([non_terminating_response_code, ''])
                                     .then
                                     .returns([terminating_response_code, 'Hello world'])

      TariffSynchronizer::DownloadService.get_content(example_url).should == "Hello world"
    end
  end
end
