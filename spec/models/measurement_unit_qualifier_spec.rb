require 'rails_helper'

describe MeasurementUnitQualifier do
  describe 'validations' do
    # MUQ1 The measurement unit qualifier code must be unique.
    it { should validate_uniqueness.of :measurement_unit_qualifier_code }
    # MUQ2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
  end
end
