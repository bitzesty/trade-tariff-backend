require 'spec_helper'

describe MeasureComponent do
  describe 'delegations' do
    it { should delegate_method(:duty_expression_description).to(:duty_expression).as(:description) }
    it { should delegate_method(:duty_expression_abbreviation).to(:duty_expression).as(:abbreviation) }
    it { should delegate_method(:monetary_unit_abbreviation).to(:monetary_unit).as(:abbreviation) }
  end
end
