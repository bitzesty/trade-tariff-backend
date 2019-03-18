module Api
  module V1
    module Measures
      class MeasureSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_sid
        set_type :measure
        attributes :id, :origin, :effective_start_date, :effective_end_date, :import,
                   :excise, :vat

        has_one :duty_expression, serializer: Api::V1::Measures::DutyExpressionSerializer
        has_one :measure_type, serializer: Api::V1::Measures::MeasureTypeSerializer
        has_many :legal_acts, serializer: Api::V1::Measures::MeasureLegalActSerializer
        has_one :suspending_regulation, key: :suspension_legal_act,
                serializer: Api::V1::Measures::MeasureSuspensionLegalActSerializer,
                if: Proc.new { |measure| !measure.national && measure.suspended? }
        has_many :measure_conditions, serializer: Api::V1::Measures::MeasureConditionSerializer
        has_one :geographical_area, serializer: Api::V1::Measures::GeographicalAreaSerializer
        has_many :excluded_geographical_areas, key: :excluded_countries,
                 record_type: :geographical_area, serializer: Api::V1::GeographicalAreaSerializer
        has_many :footnotes, serializer: Api::V1::Measures::FootnoteSerializer
        has_one :additional_code, if: Proc.new { |measure| measure.additional_code.present? }, serializer: Api::V1::Measures::AdditionalCodeSerializer
        has_one :export_refund_nomenclature, key: :additional_code,
                if: Proc.new { |measure| measure.export_refund_nomenclature.present? },
                serializer: Api::V1::Measures::ExportRefundNomenclatureSerializer

      end
    end
  end
end