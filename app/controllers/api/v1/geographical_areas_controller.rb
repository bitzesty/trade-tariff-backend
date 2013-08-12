module Api
  module V1
    class GeographicalAreasController < ApiController
      def countries
        @geographical_areas = GeographicalArea.eager(:geographical_area_descriptions)
                                              .countries
                                              .all

        respond_with @geographical_areas
      end
    end
  end
end
