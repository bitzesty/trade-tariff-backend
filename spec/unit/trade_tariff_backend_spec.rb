require 'spec_helper'

describe TradeTariffBackend do
  describe '.reindex' do
    context 'when successful' do
      let(:stub_indexer) { double(run: true) }

      before { TradeTariffBackend.reindex(stub_indexer) }

      it 'reindexes Tariff model contents in the search engine' do
        stub_indexer.should have_received(:run)
      end
    end

    context 'when failed' do
      let(:mock_indexer) { double }

      before {
        mock_indexer.should_receive(:run).and_raise(StandardError)

        TradeTariffBackend.reindex(mock_indexer)
      }

      it 'notified system operator about indexing failure' do
        ActionMailer::Base.deliveries.should_not be_empty
        email = ActionMailer::Base.deliveries.last
        email.encoded.should =~ /Backtrace/
        email.encoded.should =~ /failed to reindex/
      end
    end
  end

  describe '.platform' do
    context 'running in demo environment' do
      before { ENV['GOVUK_APP_NAME'] = 'tariff-demo-api' }
      after  { ENV['GOVUK_APP_NAME']  = nil }

      it 'returns demo' do
        expect(TradeTariffBackend.platform).to eq 'demo'
      end
    end

    context 'FACTER_govuk_platform environment variable available' do

      before { ENV['FACTER_govuk_platform'] = 'production' }
      after  { ENV['FACTER_govuk_platform'] = nil }

      it 'returns the environment variable value' do
        expect(TradeTariffBackend.platform).to eq 'production'
      end
    end

    context 'FACTER_govuk_platform environment variable unavailable' do
      it 'defaults to Rails.env' do
        expect(TradeTariffBackend.platform).to eq 'test'
      end
    end
  end
end
