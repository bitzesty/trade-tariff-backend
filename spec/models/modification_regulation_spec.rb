require 'rails_helper'

describe ModificationRegulation do
  describe 'validations' do
    # ROIMM1
    it { should validate_uniqueness.of([:modification_regulation_id, :modification_regulation_role]) }
    # ROIMM5
    it { should validate_validity_dates }
  end
end
