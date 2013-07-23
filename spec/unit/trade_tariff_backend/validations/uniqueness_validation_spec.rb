require 'spec_helper'

describe TradeTariffBackend::Validations::UniquenessValidation do
  describe '#valid?' do
    let(:validation) {
      described_class.new(:vld1, 'valid', validation_options: { of: [:a] })
    }

    context 'duplicates found' do
      let(:model)  { double(filter: [double]) }
      let(:record) { double(values: { a: 'a' },
                          model: model,
                          new?: false) }

      it 'returns false' do
        validation.valid?(record).should be_false
      end
    end

    context 'no duplicates found' do
      let(:model)  { double(filter: []) }
      let(:record) { double(values: { a: 'a' },
                          model: model) }

      it 'returns true' do
        validation.valid?(record).should be_true
      end
    end

    context 'no arguments provided to search uniquness for' do
      let(:validation) {
        described_class.new(:vld1, 'valid', validation_options: { })
      }

      it 'raises an ArgumentError' do
        expect { validation.valid?(nil) }.to raise_error ArgumentError
      end
    end
  end
end
