require 'csv'

module Api
  module V2
    class GoodsNomenclaturesController < ApiController
      def index
        commodities = GoodsNomenclature.non_hidden

        respond_with(commodities)
      end

      def show_by_section
        section = Section.where(position: params[:position]).first
        chapters = section.chapters.map(&:goods_nomenclature_item_id).map{|gn|gn[0..1]}.join('|')
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{chapters})\d{8}/)
        @goods_nomenclatures_cache_key = "goods_nomenclatures-#{params[:position]}-#{actual_date}"

        respond_with(@goods_nomenclatures)
      end

      def show_by_chapter
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:chapter_id]})\d{8}/)
        @goods_nomenclatures_cache_key = "goods_nomenclatures-#{params[:chapter_id]}-#{actual_date}"

        respond_with(@goods_nomenclatures)
      end

      def show_by_heading
        @goods_nomenclatures = GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:heading_id]})\d{6}/)
        @goods_nomenclatures_cache_key = "goods_nomenclatures-#{params[:heading_id]}-#{actual_date}"

        respond_with(@goods_nomenclatures)
      end

      private

      def respond_with(commodities)
        @commodities = commodities
        response.set_header('Date', actual_date.httpdate )

        respond_to do |format|
          format.json {
            headers['Content-Type'] = 'application/json'
            render json: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer.new(@goods_nomenclatures.to_a).serializable_hash
          }
          format.csv {
            filename = "goods_nomenclature_#{actual_date.strftime('%Y%m%d')}.csv"
            headers['Content-Type'] = 'text/csv'
            headers['Content-Disposition'] = "attachment; filename=#{filename}"
            render "api/v2/goods_nomenclatures/index"
          }
        end
      end

      def self.api_path_builder(object)
        gnid = object.goods_nomenclature_item_id
        return nil unless gnid
        case GoodsNomenclature.class_determinator.call(object)
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
