require 'spec_helper'

describe MeasureComponent do
  describe 'delegations' do
    it { should delegate_method(:monetary_unit_abbreviation).to(:monetary_unit).as(:abbreviation) }
  end
end
