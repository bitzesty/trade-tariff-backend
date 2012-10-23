require 'spec_helper'

describe MonetaryUnit do
  describe 'delegations' do
    it { should delegate_method(:description).to(:monetary_unit_description) }
    it { should delegate_method(:abbreviation).to(:monetary_unit_description) }
  end
end
