require 'rails_helper'

describe AdditionalCodeTypeMeasureType do
  describe 'validations' do
    # AMT1, AMT2
    it { should validate_presence.of([:measure_type_id, :additional_code_type_id])}
    # AMT3
    it { should validate_uniqueness.of([:measure_type_id, :additional_code_type_id])}
    # AMT5
    it { should validate_validity_dates }
  end
end
