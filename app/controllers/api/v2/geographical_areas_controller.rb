module Api
  module V1
    class GeographicalAreasController < ApiController
      def countries
        @geographical_areas = GeographicalArea.eager(:geographical_area_descriptions)
                                              .actual
                                              .countries
                                              .all

        render json:  Api::V1::GeographicalAreaSerializer.new(@geographical_areas).serializable_hash
      end
    end
  end
end
