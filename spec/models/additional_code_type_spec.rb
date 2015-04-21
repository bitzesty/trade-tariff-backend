require 'rails_helper'

describe AdditionalCodeType do
  describe 'validations' do
    # CT1 The additional code type must be unique.
    it { should validate_uniqueness.of :additional_code_type_id }
    # CT4 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }

    describe 'CT2' do
      context 'meursing table plan id present' do
        context 'application code is meursing table plan additional code type' do
          let!(:additional_code_type) { build :additional_code_type, :with_meursing_table_plan,
                                                                     :meursing }

          it 'should be valid' do
            expect(additional_code_type.conformant?).to be_truthy
          end
        end

        context 'application code is not meursing table plan additional code type' do
          let!(:additional_code_type) { build :additional_code_type, :with_meursing_table_plan,
                                                                     :adco }

          it 'should not be valid' do
            expect(additional_code_type.conformant?).to be_falsy
          end
        end
      end

      context 'meursing table plan id missing' do
        let!(:additional_code_type) { build :additional_code_type, :adco }

        it 'should be valid' do
          expect(additional_code_type.conformant?).to be_truthy
        end
      end
    end

    describe 'CT3' do
      context 'meursing table plan exists' do
        let!(:additional_code_type) { build :additional_code_type, :with_meursing_table_plan,
                                                                   :meursing }

        it 'should be valid' do
          expect(additional_code_type).to be_valid
        end
      end

      context 'meursing table plan does not exist' do
        let!(:additional_code_type) { build :additional_code_type, meursing_table_plan_id: 'XX' }

        it 'should not be valid' do
          expect(additional_code_type).to_not be_conformant
        end
      end
    end

    describe 'CT6' do
      context 'non meursing additional code' do
        let!(:additional_code_type) { create :additional_code_type }
        let!(:additional_code)      { create :additional_code, additional_code_type_id: additional_code_type.additional_code_type_id }

        before {
          additional_code_type.destroy
          additional_code_type.conformant?
        }

        specify 'The additional code type cannot be deleted if it is related with a non-Meursing additional code.' do
          expect(additional_code_type.conformance_errors.keys).to include :CT6
        end
      end

      context 'meursing additional code' do
        let!(:additional_code_type) { create :additional_code_type }
        let!(:additional_code)      { create :additional_code, additional_code_type_id: additional_code_type.additional_code_type_id }
        let!(:meursing_additional_code) { create :meursing_additional_code, additional_code: additional_code.additional_code }

        before {
          additional_code_type.destroy
          additional_code_type.conformant?
        }

        specify 'The additional code type cannot be deleted if it is related with a non-Meursing additional code.' do
          expect(additional_code_type.conformance_errors.keys).not_to include :CT6
        end
      end
    end

    describe 'CT7' do
      let(:additional_code_type) { create :additional_code_type, :with_meursing_table_plan }

      before {
        additional_code_type.destroy
        additional_code_type.conformant?
      }

      specify 'The additional code type cannot be deleted if it is related with a Meursing Table plan.' do
        expect(additional_code_type.conformance_errors.keys).to include :CT7
      end
    end

    describe 'CT9' do
      let!(:additional_code_type)       { create :additional_code_type, :ern }
      let!(:export_refund_nomenclature) { create :export_refund_nomenclature, additional_code_type: additional_code_type.additional_code_type_id }

      before {
        additional_code_type.destroy
        additional_code_type.conformant?
      }

      specify 'The additional code type cannot be deleted if it is related with an Export refund code.' do
        expect(additional_code_type.conformance_errors.keys).to include :CT9
      end
    end

    describe 'CT10' do
      let!(:measure_type)               { create :measure_type }
      let!(:additional_code_type)       { create :additional_code_type }
      let!(:additional_code_type_measure_type) { create :additional_code_type_measure_type, measure_type_id: measure_type.measure_type_id,
                                                                                            additional_code_type_id: additional_code_type.additional_code_type_id }

      before {
        additional_code_type.destroy
        additional_code_type.conformant?
      }

      specify 'The additional code type cannot be deleted if it is related with a measure type.' do
        expect(additional_code_type.conformance_errors.keys).to include :CT10
      end
    end

    describe 'CT11' do
      pending 'The additional code type cannot be deleted if it is related with an Export Refund for Processed Agricultural Goods additional code.' do
        raise "pending - to do"
      end
    end
  end
end
