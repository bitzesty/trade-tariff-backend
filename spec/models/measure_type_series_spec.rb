require 'rails_helper'

describe MeasureTypeSeries do
  describe 'validations' do
    # MTS1 The measure type series must be unique.
    it { should validate_uniqueness.of [:measure_type_series_id, :measure_type_combination] }
    # MTS3 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }

    describe 'MTS2' do
      let!(:measure_type_series) { create :measure_type_series }
      let!(:measure_type) { create :measure_type, measure_type_series_id: measure_type_series.measure_type_series_id }

      before {
        measure_type_series.destroy
        measure_type_series.conformant?
      }

      specify 'The measure type series cannot be deleted if it is associated with a measure type.' do
        expect(measure_type_series.conformance_errors.keys).to include :MTS2
      end
    end
  end
end
