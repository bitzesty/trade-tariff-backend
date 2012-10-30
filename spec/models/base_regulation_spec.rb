require 'spec_helper'

describe BaseRegulation do
  describe 'validations' do
    # ROIMB1
    it { should validate_uniqueness.of([:base_regulation_id, :base_regulation_role])}
    # ROIMB3
    it { should validate_validity_dates }
  end
end
