module Api
  module V1
    module Headings
      class MeasureTypeSerializer
        include FastJsonapi::ObjectSerializer
        set_id :measure_type_id
        set_type :measure_type
        attributes :description
        attribute :id do |measure_type|
          measure_type.measure_type_id
        end
      end
    end
  end
end