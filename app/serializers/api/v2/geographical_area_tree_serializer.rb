module Api
  module V2
    class GeographicalAreaTreeSerializer
      include JSONAPI::Serializer

      set_id :id

      set_type :geographical_area

      attributes :id, :description, :geographical_area_id

      has_many :contained_geographical_areas, key: :children_geographical_areas, record_type: :geographical_area, serializer: Api::V2::GeographicalAreaTreeSerializer
    end
  end
end
