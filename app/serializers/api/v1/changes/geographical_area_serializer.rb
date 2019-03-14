module Api
  module V1
    module Changes
      class GeographicalAreaSerializer
        include FastJsonapi::ObjectSerializer
        set_id :id
        set_type :geographical_area
        attributes :id
        attribute :description do |geographical_area|
          geographical_area.geographical_area_description.description
        end
      end
    end
  end
end