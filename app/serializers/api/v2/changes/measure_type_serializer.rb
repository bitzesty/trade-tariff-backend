module Api
  module V2
    module Changes
      class MeasureTypeSerializer
        include FastJsonapi::ObjectSerializer
        set_id :id
        set_type :measure_type
        attributes :id, :description
      end
    end
  end
end