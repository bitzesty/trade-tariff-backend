require "rails_helper"
require "tariff_synchronizer"

describe TariffSynchronizer::FileService do
  let(:klass) {
    Class.new do
      include TariffSynchronizer::FileService
    end
  }

  describe ".download_content" do
    context "partial content received" do
      it "raises DownloadException" do
        stub_request(:get, "http://example/test").to_raise(Curl::Err::PartialFileError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context "unable to connect" do
      it "raises DownloadException" do
        stub_request(:get, "http://example/test").to_raise(Curl::Err::ConnectionFailedError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context "host resolution error" do
      it "raises DownloadException" do
        stub_request(:get, "http://example/test").to_raise(Curl::Err::HostResolutionError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    it "returns response object if the request is successful" do
      stub_request(:get, "http://example/test").to_return(body: "abc")
      response = klass.download_content("http://example/test")
      expect(response.content).to eq("abc")
      expect(response.response_code).to eq(200)
    end

    it "returns retry_count_exceeded? as true when not valid request" do
      stub_request(:get, "http://example/test").to_return(status: 401)
      response = klass.download_content("http://example/test")
      expect(response.retry_count_exceeded?).to be_truthy
    end
  end
end
