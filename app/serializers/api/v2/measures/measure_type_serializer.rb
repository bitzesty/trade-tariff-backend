module Api
  module V2
    module Measures
      class MeasureTypeSerializer
        include JSONAPI::Serializer

        set_type :measure_type

        set_id :measure_type_id

        attributes :description, :national, :measure_type_series_id

        attribute :id do |measure_type|
          measure_type.measure_type_id
        end
      end
    end
  end
end
