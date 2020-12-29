module Api
  module V2
    class GeographicalAreasController < BaseController
      def index
        @geographical_areas = GeographicalArea.eager(:geographical_area_descriptions).actual.areas.all

        options = {}
        options[:include] = [:contained_geographical_areas]
        render json: Api::V2::GeographicalAreaTreeSerializer.new(@geographical_areas).serializable_hash
      end
      
      def countries
        @geographical_areas = GeographicalArea.eager(:geographical_area_descriptions).actual.countries.all

        options = {}
        options[:include] = [:contained_geographical_areas]
        render json: Api::V2::GeographicalAreaTreeSerializer.new(@geographical_areas).serializable_hash
      end
    end
  end
end
