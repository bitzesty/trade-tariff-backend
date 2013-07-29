require 'spec_helper'

describe TradeTariffBackend::Validations::ValidityDatesValidation do
  describe '#valid?' do
    let(:validation) { described_class.new(:vld1, 'validity_date') }

    context 'no validity start dates present' do
      let(:record) { double(validity_start_date: nil,
                          validity_end_date: nil) }

      it 'returns true' do
        validation.valid?(record).should be_true
      end
    end

    context 'only validity start date present' do
      let(:record) { double(validity_start_date: Date.today,
                          validity_end_date: nil) }

      it 'returns true' do
        validation.valid?(record).should be_true
      end
    end

    context 'validity end date is greater than validity start date' do
      let(:record) { double(validity_start_date: Date.yesterday,
                          validity_end_date: Date.today) }

      it 'returns true' do
        validation.valid?(record).should be_true
      end
    end

    context 'validity start date is greater than validity end date' do
      let(:record) { double(validity_start_date: Date.today,
                          validity_end_date: Date.yesterday) }

      it 'returns false' do
        validation.valid?(record).should be_false
      end
    end
  end
end
