require 'spec_helper'

describe TradeTariffBackend::Validations::ValidityDateSpanValidation do
  describe '#valid?' do
    context 'of option provided' do
      let(:validation) { described_class.new(:vld1, 'validity_date') }

      it 'raises ArgumentError' do
        expect { validation.valid?(nil) }.to raise_error ArgumentError
      end
    end

    context 'of option not provided' do
      context 'associated records validity start date is less than models' do
        let(:model) { stub(validity_start_date: Date.yesterday,
                           associated_record: stub(validity_start_date: Date.today, persisted?: true))}
        let(:validation) { described_class.new(:vld1, 'validity_date') }

        it 'should return false' do
          described_class.new(:vld1, 'validity date span validation', validation_options: { of: :associated_record }).valid?(model).should be_false
        end
      end

      context 'associated record has validity end date and model does not' do
        let(:model) { stub(validity_start_date: Date.yesterday,
                           validity_end_date: nil,
                           associated_record: stub(validity_start_date: Date.today, persisted?: true,
                                                   validity_end_date: Date.yesterday))}
        let(:validation) { described_class.new(:vld1, 'validity_date') }

        it 'should return false' do
          described_class.new(:vld1, 'validity date span validation', validation_options: { of: :associated_record }).valid?(model).should be_false
        end
      end

      context 'both have end dates but associated records validity end date is greater than models' do
        let(:model) { stub(validity_start_date: Date.yesterday,
                           validity_end_date: Date.yesterday,
                           associated_record: stub(validity_start_date: Date.today,
                                                   validity_end_date: Date.today,
                                                   persisted?: true))}
        let(:validation) { described_class.new(:vld1, 'validity_date') }

        it 'should return false' do
          described_class.new(:vld1, 'validity date span validation', validation_options: { of: :associated_record }).valid?(model).should be_false
        end
      end
    end
  end
end
