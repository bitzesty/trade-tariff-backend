require 'spec_helper'

describe MonetaryUnit do
  let(:monetary_unit) { create :monetary_unit }

  describe 'delegations' do
    it 'delegates description to monetary unit description' do
      expect { MonetaryUnit.new.description }.to raise_error RuntimeError
    end

    it 'delegates abbreviation to monetary unit description' do
      expect { MonetaryUnit.new.abbreviation }.to raise_error RuntimeError
    end
  end

  describe '#to_s' do
    it 'is an alias for monetary_unit_code' do
      monetary_unit.to_s.should eq monetary_unit.monetary_unit_code
    end
  end
end
