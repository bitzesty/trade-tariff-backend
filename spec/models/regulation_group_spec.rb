require 'spec_helper'

describe RegulationGroup do
  describe 'validations' do
    # RG1 The Regulation group id must be unique.
    it { should validate_uniqueness.of :regulation_group_id }
    # RG3 The start date must be less than or equal to the end date.
    it { should validate_validity_dates }

    describe 'RG2' do
      let!(:regulation_group) { create :regulation_group }
      let!(:base_regulation)  { create :base_regulation, regulation_group_id: regulation_group.regulation_group_id}

      specify 'The Regulation group cannot be deleted if it is used in a base regulation.' do
          expect { regulation_group.destroy }.to raise_error Sequel::HookFailed
      end
    end
  end
end
