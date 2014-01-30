module Api
  module V1
    class MeasureTypesController < ApiController
      before_filter :authenticate_user!

      def index
        @measure_types = MeasureType.eager(:measure_type_description).national.all

        respond_with @measure_types
      end

      def show
        @measure_type = MeasureType.national.with_pk!(measure_type_pk)
      end

      def update
        @measure_type = MeasureType.national.with_pk!(measure_type_pk)
        @measure_type.measure_type_description.tap do |measure_type_description|
          measure_type_description.set(measure_type_params)
          measure_type_description.save
        end

        respond_with @measure_type
      end

      private

      def measure_type_params
        params.require(:measure_type).permit(:description)
      end

      def measure_type_pk
        params.fetch(:id, '')
      end
    end
  end
end
