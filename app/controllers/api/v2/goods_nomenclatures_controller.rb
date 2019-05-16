require 'csv'

module Api
  module V2
    class GoodsNomenclaturesController < ApiController
      before_action :set_cache_key
      before_action :set_request_format, only: %w(show_by_section show_by_chapter show_by_heading)

      def index
        commodities = GoodsNomenclature.non_hidden

        respond_with(commodities)
      end

      def show_by_section
        section = Section.where(position: params[:position]).first
        chapters = section.chapters.map(&:goods_nomenclature_item_id).map { |gn| gn[0..1] }.join('|')
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{chapters})\d{8}/)

        respond_with(@goods_nomenclatures)
      end

      def show_by_chapter
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:chapter_id]})\d{8}/)

        respond_with(@goods_nomenclatures)
      end

      def show_by_heading
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:heading_id]})\d{6}/)

        respond_with(@goods_nomenclatures)
      end

      def self.api_path_builder(object)
        gnid = object.goods_nomenclature_item_id
        return nil unless gnid

        case GoodsNomenclature.class_determinator.call(object)
        when "Chapter"
          "/api/v2/chapters/#{gnid.first(2)}"
        when "Heading"
          "/api/v2/headings/#{gnid.first(4)}"
        when "Commodity"
          "/api/v2/commodities/#{gnid.first(10)}"
        else
          "/api/v2/commodities/#{gnid.first(10)}"
        end
      end
      helper_method :api_path_builder

      private

      def respond_with(commodities)
        @commodities = commodities
        response.set_header('Date', actual_date.httpdate)

        respond_to do |format|
          format.json do
            headers['Content-Type'] = 'application/json'
            render json: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer.new(@goods_nomenclatures.to_a).serializable_hash
          end
          format.csv do
            filename = "goods_nomenclature_#{actual_date.strftime('%Y%m%d')}.csv"
            headers['Content-Type'] = 'text/csv'
            headers['Content-Disposition'] = "attachment; filename=#{filename}"
            render "api/v2/goods_nomenclatures/index"
          end
        end
      end

      def set_cache_key
        key_string = params[:position] || params[:chapter_id] || params[:heading_id] || nil
        return if key_string.nil?
        
        @goods_nomenclatures_cache_key = "goods_nomenclatures-#{key_string}-#{actual_date}"
      end

      def set_request_format
        request.format = :csv if request.headers["CONTENT_TYPE"] == 'text/csv'
      end
    end
  end
end
