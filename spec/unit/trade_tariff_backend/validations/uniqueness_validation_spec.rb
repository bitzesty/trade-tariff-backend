require 'rails_helper'

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
        expect(
          validation.valid?(record)
        ).to be_falsy
      end
    end

    context 'no duplicates found' do
      let(:model)  { double(filter: []) }
      let(:record) { double(values: { a: 'a' },
                          model: model) }

      it 'returns true' do
        expect(
          validation.valid?(record)
        ).to be_truthy
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
