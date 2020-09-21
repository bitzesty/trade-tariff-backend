module Api
  module V2
    module Measures
      class NationalMeasurementUnitSerializer
        include JSONAPI::Serializer

        set_type :national_measurement_unit

        set_id do |obj|
          obj.pk.join('-')
        end

        attributes :level, :measurement_unit_code, :description, :original_description
      end
    end
  end
end
