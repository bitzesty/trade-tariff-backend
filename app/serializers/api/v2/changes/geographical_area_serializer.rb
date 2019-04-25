module Api
  module V2
    module Changes
      class GeographicalAreaSerializer
        include FastJsonapi::ObjectSerializer

        set_type :geographical_area

        set_id :id

        attributes :id
        attribute :description do |geographical_area|
          geographical_area.geographical_area_description.description
        end
      end
    end
  end
end
