require 'csv'

module Api
  module V1
    class GoodsNomenclaturesController < ApiController

      def index
        TimeMachine.at(as_of_date) do
          @commodities = GoodsNomenclature.actual
        end
        response.set_header('Date', as_of_date.httpdate )
        @class_determinator = GoodsNomenclature.class_determinator

        respond_to do |format|
          format.json {
            headers['Content-Type'] = 'application/json'
          }
          format.csv {
            filename = params[:filename]
            headers['Content-Type'] = 'text/csv'
            headers['Content-Disposition'] = "attachment; filename=#{filename}" unless filename.blank?
          }
        end
      end

      private

      def as_of_date
        @as_of ||= begin
          Date.parse(params[:as_of])
        rescue StandardError
          Date.current
        end
      end

      def api_path_builder(object)
        gnid = object.goods_nomenclature_item_id
        return nil unless gnid
        case @class_determinator.call(object)
        when "Chapter"
          "/v1/chapters/#{gnid.first(2)}.json"
        when "Heading"
          "/v1/headings/#{gnid.first(4)}.json"
        when "Commodity"
          "/v1/commodities/#{gnid.first(10)}.json"
        else
          "/v1/commodities/#{gnid.first(10)}.json"
       end
      end
      helper_method :api_path_builder
    end
  end
end
