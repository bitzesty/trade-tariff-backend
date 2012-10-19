require 'spec_helper'
require 'date'
require 'tariff_synchronizer'
require 'tariff_synchronizer/file_service'

describe TariffSynchronizer::FileService do
  describe ".write_file" do
    let(:example_content) { Forgery(:basic).text }
    let(:example_name)    { Forgery(:basic).text }
    let(:example_path)    { "tmp/#{example_name}.sample" }

    before {
      TariffSynchronizer::FileService.write_file(example_path, example_content)
    }

    it 'writes provided content to provided path' do
      File.exists?(example_path).should be_true
      File.read(example_path).should == example_content
    end

    after { File.delete(example_path) }
  end

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
        TariffSynchronizer::FileService.get_content(example_url).should == "Hello world"
      end
    end

    it 'retries if does not receive a terminating http code' do
      TariffSynchronizer::FileService.stubs(:send_request)
                                     .returns([non_terminating_response_code, ''])
                                     .then
                                     .returns([terminating_response_code, 'Hello world'])

      TariffSynchronizer::FileService.get_content(example_url).should == "Hello world"
    end
  end
end
