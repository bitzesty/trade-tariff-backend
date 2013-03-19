require 'spec_helper'

describe MeasureComponent do
  describe 'delegations' do
    it { should delegate_method(:duty_expression_description).to(:duty_expression).as(:description) }
    it { should delegate_method(:duty_expression_abbreviation).to(:duty_expression).as(:abbreviation) }
    it { should delegate_method(:monetary_unit_abbreviation).to(:monetary_unit).as(:abbreviation) }
  end

  describe 'associations' do
    describe 'duty expression' do
      it_is_associated 'one to one to', :duty_expression do
        let(:duty_expression_id) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit' do
      it_is_associated 'one to one to', :measurement_unit do
        let(:measurement_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'monetary unit' do
      it_is_associated 'one to one to', :monetary_unit do
        let(:monetary_unit_code) { Forgery(:basic).text(exactly: 3) }
      end
    end

    describe 'measurement unit qualifier' do
      it_is_associated 'one to one to', :measurement_unit_qualifier do
        let(:measurement_unit_qualifier_code) { Forgery(:basic).text(exactly: 1) }
      end
    end
  end
end
