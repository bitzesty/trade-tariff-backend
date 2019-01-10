require 'rails_helper'

describe ModificationRegulation do
  describe 'validations' do
    # ROIMM1
    it { is_expected.to validate_uniqueness.of(%i[modification_regulation_id modification_regulation_role]) }
    # ROIMM5
    it { is_expected.to validate_validity_dates }
  end
end
