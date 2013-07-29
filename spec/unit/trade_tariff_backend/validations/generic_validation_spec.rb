require 'spec_helper'

describe TradeTariffBackend::Validations::GenericValidation do
  describe 'initialization' do
    context 'invalid operation provided' do
      it 'raises ArgumentError' do
        expect { described_class.new(:vld1, 'description', on: [:delete, :wat]) { true } }.to raise_error ArgumentError
      end
    end
  end

  describe '#operations' do
    context 'validation definition contains operations list' do
      let(:validation) { described_class.new(:vld1, 'description', on: [:destroy]) { true } }

      it 'returns defined operation list' do
        validation.operations.should eq [:destroy]
      end
    end

    context 'validation definition does not contain operation list' do
      let(:validation) { described_class.new(:vld1, 'description') { true } }

      it 'returns default (all) operation list' do
        validation.operations.should eq TradeTariffBackend::Validations::GenericValidation::DEFAULT_OPERATIONS
      end
    end
  end

  describe "#type" do
    it 'returns validation name as symbol' do
      described_class.new(:vld1, 'description') { true }.type.should eq :generic
    end
  end

  describe '#valid?' do
    context 'validation block returns true' do
      let(:validation) { described_class.new(:vld1, 'description') { true } }

      it 'returns true' do
        validation.valid?.should be_true
      end
    end

    context 'validation block returns false' do
      let(:validation) { described_class.new(:vld1, 'description') { false } }

      it 'returns false' do
        validation.valid?.should be_false
      end
    end
  end

  describe 'relevant_for?' do
    let(:validation) {
      described_class.new(:vld1, 'description', {
        if: ->(record) { record.criteria }
      } ) { true }
    }

    context 'relevant for the record' do
      let(:record) { double(criteria: true) }

      it 'returns true' do
        validation.relevant_for?(record).should eq true
      end
    end

    context 'irrelevant for the record' do
      let(:record) { double(criteria: false) }

      it 'returns false' do
        validation.relevant_for?(record).should eq false
      end
    end
  end

  describe '#to_s' do
    let(:validation) { described_class.new(:vld1, 'description') { false } }

    it 'composes validation identifier and description' do
      validation.to_s.should eq validation.description
    end
  end
end
