module Api
  module V1
    module Headings
      class MeasureSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_sid
        set_type :measure
        attributes :id, :origin, :effective_start_date, :effective_end_date, :import
        attribute :excise do |measure|
          measure.excise?
        end
        attribute :vat do |measure|
          measure.vat?
        end
        attribute :duty_expression do |measure, params|
          {
              base: measure.duty_expression_with_national_measurement_units_for(params[:declarable]),
              formatted_base: measure.formatted_duty_expression_with_national_measurement_units_for(params[:declarable])
          }
        end

        has_one :measure_type, serializer: Api::V1::Headings::MeasureTypeSerializer
        has_many :legal_acts, serializer: Api::V1::Headings::MeasureLegalActSerializer
        has_one :suspending_regulation, key: :suspension_legal_act,
                serializer: Api::V1::Headings::MeasureSuspensionLegalActSerializer,
                if: Proc.new { |measure| !measure.national && measure.suspended? }
        has_many :measure_conditions, serializer: Api::V1::Headings::MeasureConditionSerializer

      end
    end
  end
end