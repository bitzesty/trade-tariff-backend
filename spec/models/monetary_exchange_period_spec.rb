require 'rails_helper'

describe MonetaryExchangePeriod do
  let(:monetary_exchange_period) { create :monetary_exchange_period }

  describe '#to_s' do
    it 'is an alias for monetary_unit_code' do
      expect(monetary_unit.to_s).to eq monetary_unit.monetary_unit_code
    end
  end
end
