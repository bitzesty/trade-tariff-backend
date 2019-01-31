require 'rails_helper'

describe AdditionalCodeTypeMeasureType do
  describe 'validations' do
    # AMT1, AMT2
    it { is_expected.to validate_presence.of(%i[measure_type_id additional_code_type_id]) }
    # AMT3
    it { is_expected.to validate_uniqueness.of(%i[measure_type_id additional_code_type_id]) }
    # AMT5
    it { is_expected.to validate_validity_dates }
  end
end
