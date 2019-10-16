module Api
  module Admin
    class MeasureTypeSerializer
      include FastJsonapi::ObjectSerializer

      set_type :measure_type

      set_id :measure_type_id

      attributes :description, :validity_start_date, :validity_end_date
    end
  end
end
