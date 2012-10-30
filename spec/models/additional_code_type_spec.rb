require 'spec_helper'

describe AdditionalCodeType do
  describe 'validations' do
    # CT1 The additional code type must be unique.
    it { should validate_uniqueness.of :additional_code_type_id }
    # CT2 The Meursing table plan can only be entered if the additional code
    # type has as application code "Meursing table additional code type".
    it { should validate_input.of(:meursing_table_plan_id).if(:meursing?) }
    # CT3 The Meursing table plan must exist.
    it { should validate_associated(:meursing_table_plan).and_ensure(:meursing_table_plan_present?)
                                                         .if(:should_validate_meursing_table_plan?)}
    # CT4 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }

    describe 'CT6' do
      context 'non meursing additional code' do
        let!(:additional_code_type) { create :additional_code_type }
        let!(:additional_code)      { create :additional_code, additional_code_type_id: additional_code_type.additional_code_type_id }

        specify 'The additional code type cannot be deleted if it is related with a non-Meursing additional code.' do
          expect { additional_code_type.destroy }.to raise_error Sequel::HookFailed
        end
      end

      context 'meursing additional code' do
        let!(:additional_code_type) { create :additional_code_type }
        let!(:additional_code)      { create :additional_code, additional_code_type_id: additional_code_type.additional_code_type_id }
        let!(:meursing_additional_code) { create :meursing_additional_code, additional_code: additional_code.additional_code }

        specify 'The additional code type cannot be deleted if it is related with a non-Meursing additional code.' do
          expect { additional_code_type.destroy }.to_not raise_error Sequel::HookFailed
        end
      end
    end

    describe 'CT7' do
      let(:additional_code_type) { create :additional_code_type, :with_meursing_table_plan }

      specify 'The additional code type cannot be deleted if it is related with a Meursing Table plan.' do
        expect { additional_code_type.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'CT9' do
      let!(:additional_code_type)       { create :additional_code_type, :ern }
      let!(:export_refund_nomenclature) { create :export_refund_nomenclature, additional_code_type: additional_code_type.additional_code_type_id }

      specify 'The additional code type cannot be deleted if it is related with an Export refund code.' do
        expect { additional_code_type.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'CT10' do
      let!(:measure_type)               { create :measure_type }
      let!(:additional_code_type)       { create :additional_code_type }
      let!(:additional_code_type_measure_type) { create :additional_code_type_measure_type, measure_type_id: measure_type.measure_type_id,
                                                                                            additional_code_type_id: additional_code_type.additional_code_type_id }

      specify 'The additional code type cannot be deleted if it is related with a measure type.' do
        expect { additional_code_type.destroy }.to raise_error Sequel::HookFailed
      end
    end

    describe 'CT11' do
      specify 'The additional code type cannot be deleted if it is related with an Export Refund for Processed Agricultural Goods additional code.' do
        pending
      end
    end
  end
end
