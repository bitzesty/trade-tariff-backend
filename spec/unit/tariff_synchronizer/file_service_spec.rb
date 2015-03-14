require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::FileService do
  let(:klass) {
    Class.new do
      include TariffSynchronizer::FileService
    end
  }

  describe '.download_content' do
    context 'partial content received' do
      before {
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::PartialFileError)
      }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'unable to connect' do
      before {
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::ConnectionFailedError)
      }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'host resultion error' do
      before {
        allow_any_instance_of(Curl::Easy).to receive(:perform).and_raise(Curl::Err::HostResolutionError)
      }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end
  end
end
