require 'rails_helper'

describe TradeTariffBackend do
  describe '.reindex' do
    context 'when successful' do
      let(:stub_indexer) { double(update: true) }

      before { described_class.reindex(stub_indexer) }

      it 'reindexes Tariff model contents in the search engine' do
        expect(stub_indexer).to have_received(:update)
      end
    end

    context 'when failed' do
      let(:mock_indexer) { double }

      before {
        expect(mock_indexer).to receive(:update).and_raise(StandardError)

        described_class.reindex(mock_indexer)
      }

      it 'notified system operator about indexing failure' do
        expect(ActionMailer::Base.deliveries).not_to be_empty
        email = ActionMailer::Base.deliveries.last
        expect(email.encoded).to match /Backtrace/
        expect(email.encoded).to match /failed to reindex/
      end
    end
  end

  describe '.platform' do
    context 'platform should be Rails.env' do
      it 'defaults to Rails.env' do
        expect(described_class.platform).to eq Rails.env
      end
    end
  end
end
