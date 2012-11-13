require 'spec_helper'
require 'date'
require 'tariff_synchronizer'
require 'tariff_synchronizer/file_service'

describe TariffSynchronizer::FileService do
  subject {
    Class.new do
      include TariffSynchronizer::FileService
    end
  }

  describe ".write_file" do
    let(:example_content) { Forgery(:basic).text }
    let(:example_name)    { Forgery(:basic).text }
    let(:example_path)    { "tmp/#{example_name}.sample" }

    before {
      subject.write_file(example_path, example_content)
    }

    it 'writes provided content to provided path' do
      File.exists?(example_path).should be_true
      File.read(example_path).should == example_content
    end

    after { File.delete(example_path) }
  end

  describe ".download_content", :webmock do
    let(:example_url) { "http://example.com/data" }
    let(:error_response)   { build :response, :failed }
    let(:success_response) { build :response, :success, content: 'Hello world',
                                                        url: example_url }

    before do
      TariffSynchronizer.username = nil
      TariffSynchronizer.password = nil
      TariffSynchronizer.request_throttle = 0
    end

    it 'downloads content from remote url' do
      VCR.use_cassette('example_get_content') do
        subject.download_content(example_url).should == success_response
      end
    end

    it 'retries if does not receive a terminating http code' do
      subject.stubs(:send_request)
             .returns(error_response)
             .then
             .returns(success_response)

      subject.download_content(example_url).should == success_response
    end

    it 'retries until preset retry count is reached' do
      TariffSynchronizer.retry_count = 2
      subject.expects(:send_request)
             .times(3)
             .returns(error_response)

      subject.download_content(example_url).should == error_response
    end
  end
end
