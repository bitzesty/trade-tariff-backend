require 'spec_helper'

describe MeasureComponent do
  describe 'delegations' do
    it 'delegates duty expression description to duty expression' do
      expect { MeasureComponent.new.duty_expression_description }.to raise_error RuntimeError
    end

    it 'delegates duty expression abbreviation to duty expression' do
      expect { MeasureComponent.new.duty_expression_abbreviation }.to raise_error RuntimeError
    end

    it 'delegates monetary unit abbreviation to monetary unit' do
      MeasureComponent.new.should respond_to :monetary_unit_abbreviation
    end
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
