require 'rails_helper'

describe RegulationRoleType do
  describe 'validations' do
    # RT5
    it { is_expected.to validate_validity_dates }
  end
end
