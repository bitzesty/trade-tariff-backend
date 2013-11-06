require 'spec_helper'
require 'requirement_duty_expression_formatter'

describe RequirementDutyExpressionFormatter do
  describe '.format' do
    context 'duty amount present' do
      it 'result includes duty amount' do
        RequirementDutyExpressionFormatter.format(duty_amount: '55').should =~ /55/
      end
    end

    context 'monetary unit, measurement unit & measurement_unit_qualifier are present ' do
      subject {
        RequirementDutyExpressionFormatter.format(measurement_unit: 'Tonne',
                                                  formatted_measurement_unit_qualifier: 'L',
                                                  monetary_unit: 'EUR')
      }

      it 'properly formats output' do
        subject.should =~ /EUR\/\(Tonne\/L\)/
      end
    end

    context 'monetary unit and measurement unit are present' do
      subject {
        RequirementDutyExpressionFormatter.format(monetary_unit: 'EUR',
                                                  measurement_unit: 'KG')
      }

      it 'properly formats result' do
        subject.should =~ /EUR\/KG/
      end
    end

    context 'measurement unit is present' do
      subject {
        RequirementDutyExpressionFormatter.format(measurement_unit: 'KG')
      }

      it 'properly formats output' do
        subject.should =~ /KG/
      end
    end
  end
end
