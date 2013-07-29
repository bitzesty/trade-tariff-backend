require 'spec_helper'

describe MeasureCondition do
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

    describe 'certificate' do
      it_is_associated 'one to one to', :certificate do
        let!(:certificate_code) { Forgery(:basic).text(exactly: 3) }
        let!(:certificate_type_code) { Forgery(:basic).text(exactly: 1) }
      end
    end

    describe 'measure condition components' do
      let!(:measure_condition)                { create :measure_condition }
      let!(:measure_condition_component1)     { create :measure_condition_component, measure_condition_sid: measure_condition.measure_condition_sid }
      let!(:measure_condition_component2)     { create :measure_condition_component, measure_condition_sid: generate(:measure_condition_sid)  }

      context 'direct loading' do
        it 'loads associated measure condition components' do
          measure_condition.measure_condition_components.should include measure_condition_component1
        end

        it 'does not load associated measure component' do
          measure_condition.measure_condition_components.should_not include measure_condition_component2
        end
      end

      context 'eager loading' do
        it 'loads associated measure components' do
          MeasureCondition.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components.should include measure_condition_component1
        end

        it 'does not load associated measure component' do
          MeasureCondition.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components.should_not include measure_condition_component2
        end
      end
    end
  end
end
