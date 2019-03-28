module Api
  module V2
    module Changes
      class MeasureTypeSerializer
        include FastJsonapi::ObjectSerializer

        set_type :measure_type

        set_id :id

        attributes :id, :description
      end
    end
  end
end
