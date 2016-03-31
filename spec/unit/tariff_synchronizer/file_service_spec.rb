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
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::PartialFileError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context "unable to connect" do
      it "raises DownloadException" do
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::ConnectionFailedError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context "host resolution error" do
      it "raises DownloadException" do
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::HostResolutionError)
        expect { klass.download_content("http://example/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end
  end
end
