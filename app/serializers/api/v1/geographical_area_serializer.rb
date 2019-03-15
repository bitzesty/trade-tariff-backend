module Api
  module V1
    class GeographicalAreaSerializer
      include FastJsonapi::ObjectSerializer

      set_id :id

      set_type :geographical_area

      attributes :description
    end
  end
end
