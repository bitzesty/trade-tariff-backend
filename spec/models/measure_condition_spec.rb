require 'spec_helper'

describe MeasureCondition do
  it { should delegate_method(:monetary_unit_abbreviation).to(:monetary_unit).as(:abbreviation) }

  describe 'associations' do
    describe 'monetary unit' do
      it_is_associated 'one to one to', :monetary_unit do
        let!(:left_primary_key) { :condition_monetary_unit_code }
        let!(:monetary_unit_code) { Forgery(:basic).text(exactly: 3) }
        let!(:condition_monetary_unit_code) { monetary_unit_code }
      end
    end

    describe 'measurement unit' do
      it_is_associated 'one to one to', :measurement_unit do
        let!(:left_primary_key) { :condition_measurement_unit_code }
        let!(:measurement_unit_code) { Forgery(:basic).text(exactly: 3) }
        let!(:condition_measurement_unit_code) { measurement_unit_code }
      end
    end

    describe 'measurement unit qualifier' do
      it_is_associated 'one to one to', :measurement_unit_qualifier do
        let!(:left_primary_key) { :condition_measurement_unit_qualifier_code }
        let!(:measurement_unit_qualifier_code) { Forgery(:basic).text(exactly: 1) }
        let!(:condition_measurement_unit_qualifier_code) { measurement_unit_qualifier_code }
      end
    end

    describe 'measure condition code' do
      it_is_associated 'one to one to', :measure_condition_code do
        let!(:condition_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'measure action' do
      it_is_associated 'one to one to', :measure_action do
        let!(:action_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'certificate type' do
      it_is_associated 'one to one to', :certificate_type do
        let!(:certificate_type_code) { Forgery(:basic).text(exactly: 1) }
      end
    end
>>>>>>> Additional associations.
  end
end
