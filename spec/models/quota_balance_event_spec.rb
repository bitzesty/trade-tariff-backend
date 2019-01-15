require 'rails_helper'

describe QuotaBalanceEvent do
  describe '.last' do
    let!(:balance_event1) {
      create :quota_balance_event,
                                      occurrence_timestamp: 3.days.ago
    }
    let!(:balance_event2) {
      create :quota_balance_event,
                                      occurrence_timestamp: 1.days.ago
    }
    let!(:balance_event3) {
      create :quota_balance_event,
                                      occurrence_timestamp: 2.days.ago
    }

    it 'orders items by desc occurrence_timestamp' do
      expect(described_class.last).to eq(balance_event2)
    end
  end

  describe '.status' do
    it "returns 'open' string" do
      expect(described_class.status).to eq('open')
    end
  end
end
