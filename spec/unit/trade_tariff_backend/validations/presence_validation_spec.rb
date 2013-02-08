require 'spec_helper'

describe TradeTariffBackend::Validations::PresenceValidation do
  describe '#valid?' do
    let(:record) { stub(a: 'a', b: 'b', c: nil) }

    context 'all arguments are present on record' do
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: [:a, :b] })
      }

      it 'returns true' do
        validation.valid?(record).should be_true
      end
    end

    context 'some arguments are present on record' do
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { of: [:a, :b, :c] })
      }

      it 'returns false' do
        validation.valid?(record).should be_false
      end
    end
  end
end
