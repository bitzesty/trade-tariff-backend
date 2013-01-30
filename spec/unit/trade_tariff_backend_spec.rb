require 'spec_helper'

describe TradeTariffBackend do
  describe '.reindex' do
    context 'when successful' do
      let(:stub_indexer) { stub(run: true) }

      before { TradeTariffBackend.reindex(stub_indexer) }

      it 'reindexes Tariff model contents in the search engine' do
        stub_indexer.should have_received(:run)
      end
    end

    context 'when failed' do
      let(:mock_indexer) { mock }

      before {
        mock_indexer.expects(:run).raises(StandardError)

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
end
