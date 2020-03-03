module Api
  module V2
    module Measures
      class MeasureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :measure

        set_id :measure_sid

        attributes :id, :origin, :effective_start_date, :effective_end_date, :import,
                   :excise, :vat

        has_one :duty_expression, serializer: Api::V2::Measures::DutyExpressionSerializer
        has_one :measure_type, serializer: Api::V2::Measures::MeasureTypeSerializer
        has_many :legal_acts, serializer: Api::V2::Measures::MeasureLegalActSerializer
        has_one :suspending_regulation, key: :suspension_legal_act,
                record_type: :suspension_legal_act, serializer: Api::V2::Measures::MeasureSuspensionLegalActSerializer,
                if: Proc.new { |measure| !measure.national && measure.suspended? }
        has_many :measure_conditions, serializer: Api::V2::Measures::MeasureConditionSerializer
        has_many :measure_components, serializer: Api::V2::Measures::MeasureComponentSerializer
        has_many :national_measurement_units, serializer: Api::V2::Measures::NationalMeasurementUnitSerializer
        has_one :geographical_area, serializer: Api::V2::Measures::GeographicalAreaSerializer
        has_many :excluded_geographical_areas, key: :excluded_countries,
                 record_type: :geographical_area, serializer: Api::V2::GeographicalAreaSerializer
        has_many :footnotes, serializer: Api::V2::Measures::FootnoteSerializer
        has_one :additional_code, if: Proc.new { |measure| measure.additional_code.present? }, serializer: Api::V2::AdditionalCodeSerializer
        has_one :order_number, serializer: Api::V2::Quotas::OrderNumber::QuotaOrderNumberSerializer
      end
    end
  end
end
