require 'rails_helper'

describe Measurement do
  describe 'validations' do
    describe 'MENT1' do
      it { should validate_uniqueness.of([:measurement_unit_code, :measurement_unit_qualifier_code]) }
    end

    describe 'MENT6' do
      it { should validate_validity_dates }
    end
  end
end
