module Api
  module V2
    class GeographicalAreasController < ApiController
      def index
        @geographical_areas = GeographicalArea
                                .actual
                                .areas
                                .all
  
        render json:  Api::V2::GeographicalAreaSerializer.new(@geographical_areas).serializable_hash
      end
      
      def countries
        @geographical_areas = GeographicalArea.eager(:geographical_area_descriptions)
                                              .actual
                                              .countries
                                              .all

        render json:  Api::V2::GeographicalAreaSerializer.new(@geographical_areas).serializable_hash
      end
    end
  end
end
