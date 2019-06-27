module Api
  module V2
    module Quotas
      module Definition
        class QuotaDefinitionSerializer
          include FastJsonapi::ObjectSerializer

          set_type :definition

          set_id :quota_definition_sid

          attributes :quota_definition_sid, :quota_order_number_id, :initial_volume, :validity_start_date, :validity_end_date, :status, :description, :balance

          attribute :measurement_unit do |definition|
            definition.formatted_measurement_unit
          end

          attribute :monetary_unit do |definition|
            definition.monetary_unit_code
          end

          attribute :measurement_unit_qualifier do |definition|
            definition.measurement_unit_qualifier_code
          end

          attribute :last_allocation_date do |definition|
            definition.last_balance_event.try(:occurrence_timestamp)
          end

          attribute :suspension_period_start_date do |definition|
            definition.last_suspension_period.try(:suspension_start_date)
          end

          attribute :suspension_period_end_date do |definition|
            definition.last_suspension_period.try(:suspension_end_date)
          end

          attribute :blocking_period_start_date do |definition|
            definition.last_blocking_period.try(:blocking_start_date)
          end

          attribute :blocking_period_end_date do |definition|
            definition.last_blocking_period.try(:blocking_end_date)
          end

          has_one :quota_order_number, key: :order_number, record_type: :order_number, serializer: Api::V2::Quotas::Definition::QuotaOrderNumberSerializer
          has_many :measures, serializer: Api::V2::Quotas::Definition::MeasureSerializer
        end
      end
    end
  end
end
