require 'spec_helper'

describe MeasurementUnit do
  let(:measurement_unit) { create :measurement_unit, :with_description }

  describe '#to_s' do
    it 'is an alias for description' do
      measurement_unit.to_s.should eq measurement_unit.description
    end
  end

  describe 'validations' do
    # MU1 The measurement unit code must be unique.
    it { should validate_uniqueness.of(:measurement_unit_code) }
    # MU2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
  end
end
