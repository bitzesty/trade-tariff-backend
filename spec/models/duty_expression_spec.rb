require 'rails_helper'

describe DutyExpression do
  describe 'validations' do
    # DE1: The code of the duty expression must be unique.
    it { should validate_uniqueness.of :duty_expression_id }
    # DE2: The start date must be less than or equal to the end date.
    it { should validate_validity_dates }
  end
end
