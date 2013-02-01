require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::FileService do
  let(:klass) {
    Class.new do
      include TariffSynchronizer::FileService
    end
  }

  describe '.download_content' do
    context 'partial content received' do
      before { Curl::Easy.any_instance.expects(:perform).raises(Curl::Err::PartialFileError) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'unable to connect' do
      before { Curl::Easy.any_instance.expects(:perform).raises(Curl::Err::ConnectionFailedError) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'host resultion error' do
      before { Curl::Easy.any_instance.expects(:perform).raises(Curl::Err::HostResolutionError) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end
  end
end
