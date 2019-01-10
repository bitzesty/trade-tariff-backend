require 'rails_helper'

describe Language do
  describe 'validations' do
    # LA1
    it { is_expected.to validate_uniqueness.of(:language_id) }
    # LA3
    it { is_expected.to validate_validity_dates }
  end
end
