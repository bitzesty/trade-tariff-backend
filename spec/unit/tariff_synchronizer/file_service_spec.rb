require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::FileService do
  let(:klass) {
    Class.new do
      include TariffSynchronizer::FileService
    end
  }

  describe '.download_content' do
    before {
      Faraday::Connection.any_instance.should_receive(:get).and_raise(error)
    }

    context 'client error' do
      let(:error) { Faraday::Error::ClientError.new(nil) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'unable to connect' do
      let(:error) { Faraday::Error::ConnectionFailed.new(nil) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end

    context 'resource not found' do
      let(:error) { Faraday::Error::ResourceNotFound.new(nil) }

      it 'raises DownloadException' do
        expect { klass.download_content("http://localhost:9999/test") }.to raise_error TariffSynchronizer::FileService::DownloadException
      end
    end
  end
end
