module Api
  module V2
    class GeographicalAreaSerializer
      include FastJsonapi::ObjectSerializer

      set_id :id

      set_type :geographical_area

      attributes :id, :description
    end
  end
end
