require 'rails_helper'
require 'requirement_duty_expression_formatter'

describe RequirementDutyExpressionFormatter do
  describe '.format' do
    let(:measurement_unit) {
      measurement_unit_abbreviation.measurement_unit
    }
    let(:unit) {
      measurement_unit.abbreviation(measurement_unit_qualifier: measurement_unit_qualifier)
    }
    let!(:measurement_unit_abbreviation) {
      create(:measurement_unit_abbreviation, :with_measurement_unit, :include_qualifier)
    }
    let!(:measurement_unit_qualifier) {
      create(:measurement_unit_qualifier, measurement_unit_qualifier_code: measurement_unit_abbreviation.measurement_unit_qualifier)
    }

    context 'duty amount present' do
      it 'result includes duty amount' do
        expect(
          RequirementDutyExpressionFormatter.format(duty_amount: '55')
        ).to match /55/
      end
    end

    context 'monetary unit, measurement unit & measurement_unit_qualifier are present ' do
      subject {
        RequirementDutyExpressionFormatter.format(measurement_unit: measurement_unit,
                                                  formatted_measurement_unit_qualifier: 'L',
                                                  monetary_unit: 'EUR')
      }

      it 'properly formats output' do
        expect(subject).to match /EUR \/ \(#{measurement_unit.description} \/ L\)/
      end
    end

    context 'monetary unit and measurement unit are present' do
      subject {
        RequirementDutyExpressionFormatter.format(monetary_unit: 'EUR',
                                                  measurement_unit: measurement_unit)
      }

      it 'properly formats result' do
        expect(subject).to match /EUR \/ #{measurement_unit.description}/
      end
    end

    context 'measurement unit is present' do
      subject {
        RequirementDutyExpressionFormatter.format(measurement_unit: measurement_unit)
      }

      it 'properly formats output' do
        expect(subject).to match Regexp.new(measurement_unit.description)
      end
    end
  end

  describe '.prettify' do
    context 'has less than 4 decimal places' do
      it 'returns number with insignificant zeros stripped up to 2 decimal points' do
        expect(RequirementDutyExpressionFormatter.prettify(1.2)).to eq '1.20'
      end
    end

    context 'has 4 or more decimal places' do
      it 'returns formatted number with 4 decimal places' do
        expect(RequirementDutyExpressionFormatter.prettify(1.23456)).to eq '1.2346'
      end
    end
  end
end
