require 'spec_helper'

describe Language do
  describe 'validations' do
    # LA1
    it { should validate_uniqueness.of(:language_id) }
    # LA3
    it { should validate_validity_dates }
  end
end
