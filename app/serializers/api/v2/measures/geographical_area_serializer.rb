module Api
  module V2
    module Measures
      class GeographicalAreaSerializer
        include FastJsonapi::ObjectSerializer
        set_id :id
        set_type :geographical_area
        attributes :id, :description
        has_many :children_geographical_areas, key: :contained_geographical_areas, serializer: Api::V2::GeographicalAreaSerializer
      end
    end
  end
end