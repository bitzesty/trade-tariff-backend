require 'rails_helper'

describe RegulationRoleType do
  describe 'validations' do
    # RT5
    it { should validate_validity_dates }
  end
end
