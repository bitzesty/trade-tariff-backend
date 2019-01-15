require 'rails_helper'

describe Measurement do
  describe 'validations' do
    describe 'MENT1' do
      it { is_expected.to validate_uniqueness.of(%i[measurement_unit_code measurement_unit_qualifier_code]) }
    end

    describe 'MENT6' do
      it { is_expected.to validate_validity_dates }
    end
  end
end
