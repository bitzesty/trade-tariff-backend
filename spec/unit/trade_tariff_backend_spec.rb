require 'spec_helper'

describe TradeTariffBackend do
  describe '.reindex' do
    context 'when successful' do
      let(:stub_indexer) { double(reindex: true) }

      before { TradeTariffBackend.reindex(stub_indexer) }

      it 'reindexes Tariff model contents in the search engine' do
        stub_indexer.should have_received(:reindex)
      end
    end

    context 'when failed' do
      let(:mock_indexer) { double }

      before {
        mock_indexer.should_receive(:reindex).and_raise(StandardError)

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
    context 'platform should be Rails.env' do
      it 'defaults to Rails.env' do
        expect(TradeTariffBackend.platform).to eq Rails.env
      end
    end
  end
end
