require 'rails_helper'

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
          expect(
            measure_condition.measure_condition_components
          ).to include measure_condition_component1
        end

        it 'does not load associated measure component' do
          expect(
            measure_condition.measure_condition_components
          ).to_not include measure_condition_component2
        end
      end

      context 'eager loading' do
        it 'loads associated measure components' do
          expect(
            MeasureCondition.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components
          ).to include measure_condition_component1
        end

        it 'does not load associated measure component' do
          expect(
            MeasureCondition.where(measure_condition_sid: measure_condition.measure_condition_sid)
                 .eager(:measure_condition_components)
                 .all
                 .first
                 .measure_condition_components
          ).to_not include measure_condition_component2
        end
      end
    end
  end

  describe '#requirement' do
    context 'with document requirement' do
      let(:certificate_type) {
        create :certificate_type, :with_description,
          description: 'FOO'
      }
      let(:certificate_description) {
        create :certificate_description, :with_period,
          certificate_type_code: certificate_type.certificate_type_code,
          description: 'BAR'
      }
      let(:certificate) {
        create :certificate,
          certificate_code: certificate_description.certificate_code,
          certificate_type_code: certificate_description.certificate_type_code
      }
      let(:measure_condition) {
        create :measure_condition,
          condition_code: 'L',
          component_sequence_number: 3,
          condition_duty_amount: nil,
          condition_monetary_unit_code: nil,
          condition_measurement_unit_code: nil,
          condition_measurement_unit_qualifier_code: nil,
          certificate_code: certificate.certificate_code,
          certificate_type_code: certificate.certificate_type_code
      }

      it 'returns requirement certificate type and description' do
        expect(measure_condition.requirement).to eq "FOO: BAR"
      end
    end

    context 'with duty expression requirement' do
      let(:monetary_unit) {
        create :monetary_unit, :with_description,
          monetary_unit_code: 'FOO'
      }
      let(:measurement_unit) {
        create :measurement_unit, :with_description,
          description: 'BAR'
      }

      let(:measure_condition) {
        create :measure_condition,
          condition_code: 'L',
          component_sequence_number: 3,
          condition_duty_amount: 108.56,
          condition_monetary_unit_code: monetary_unit.monetary_unit_code,
          condition_measurement_unit_code: measurement_unit.measurement_unit_code,
          condition_measurement_unit_qualifier_code: nil,
          certificate_code: nil,
          certificate_type_code: nil
      }

      it 'returns rendered requirement duty expression' do
        expect(measure_condition.requirement).to eq "108.56 FOO/BAR"
      end
    end
  end
end
