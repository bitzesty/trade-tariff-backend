module Api
  module V1
    class GeographicalAreasController < ApiController
      def countries
        @geographical_areas = GeographicalArea.eager_graph(:geographical_area_descriptions)
                                              .actual
                                              .countries
                                              .all

        respond_with @geographical_areas
      end
    end
  end
end
