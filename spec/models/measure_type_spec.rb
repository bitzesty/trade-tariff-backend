require 'spec_helper'

describe MeasureType do
  describe 'validations' do
    # MT1 The measure type code must be unique.
    it { should validate_uniqueness.of :measure_type_id }
    # MT2 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
    # MT4 The referenced measure type series must exist.
    it { should validate_presence.of(:measure_type_series) }
  end
end
