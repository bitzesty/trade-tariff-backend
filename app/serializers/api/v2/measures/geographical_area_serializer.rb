module Api
  module V2
    module Measures
      class GeographicalAreaSerializer
        include FastJsonapi::ObjectSerializer

        set_type :geographical_area

        set_id :id

        attributes :id, :description, :geographical_area_id

        has_many :contained_geographical_areas, key: :children_geographical_areas, record_type: :geographical_area, serializer: Api::V2::GeographicalAreaSerializer
      end
    end
  end
end
