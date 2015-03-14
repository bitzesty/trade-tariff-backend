require 'rails_helper'

describe TradeTariffBackend::Validations::InclusionValidation do
  describe '#valid?' do
    let(:validation) {
      described_class.new(:vld1, 'valid', validation_options: { of: :attr,
                                                         in: [:a, :b, :c] } )
    }

    context 'valid array to check upon provided' do
      context 'array includes records attribute value' do
        let(:record) { double(attr: :c) }

        it 'returns true' do
          expect(
            validation.valid?(record)
          ).to be_truthy
        end
      end

      context 'array does not include records attribute value' do
        let(:record) { double(attr: :d) }

        it 'returns false' do
          expect(
            validation.valid?(record)
          ).to be_falsy
        end
      end
    end

    context 'no valid array to check upon provided' do
      let(:record) { double }
      let(:validation) {
        described_class.new('valid', validation_options: { of: :attr} )
      }

      it 'raises ArgumentError' do
        expect { validation.valid?(record) }.to raise_error ArgumentError
      end
    end

    context 'no valid argument to check for povided' do
      let(:record) { double }
      let(:validation) {
        described_class.new('valid', validation_options: { in: :attr} )
      }

      it 'raises ArgumentError' do
        expect { validation.valid?(record) }.to raise_error ArgumentError
      end
    end
  end
end
