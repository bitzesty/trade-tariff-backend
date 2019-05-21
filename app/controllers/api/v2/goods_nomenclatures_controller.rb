require 'csv'

module Api
  module V2
    class GoodsNomenclaturesController < ApiController
      before_action :set_cache_key

      def index
        commodities = GoodsNomenclature.non_hidden

        respond_with(commodities)
      end

      def show_by_section
        section = Section.where(position: params[:position]).first
        chapters = section.chapters.map(&:goods_nomenclature_item_id).map { |gn| gn[0..1] }.join('|')
        @goods_nomenclatures = Rails.cache.fetch('_' + @goods_nomenclatures_cache_key, expires_in: seconds_till_midnight) do
          GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{chapters})\d{8}/).all
        end

        respond_with(@goods_nomenclatures)
      end

      def show_by_chapter
        @goods_nomenclatures = Rails.cache.fetch('_' + @goods_nomenclatures_cache_key, expires_in: seconds_till_midnight) do
          GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:chapter_id]})\d{8}/).all
        end

        respond_with(@goods_nomenclatures)
      end

      def show_by_heading
        @goods_nomenclatures = Rails.cache.fetch('_' + @goods_nomenclatures_cache_key, expires_in: 300) do
          GoodsNomenclature.actual.non_hidden.where(goods_nomenclature_item_id: /(#{params[:heading_id]})\d{6}/).all
        end
        respond_with(@goods_nomenclatures)
      end

      def self.api_path_builder(object)
        gnid = object.goods_nomenclature_item_id
        return nil unless gnid

        case GoodsNomenclature.class_determinator.call(object)
        when "Chapter"
          "/v2/chapters/#{gnid.first(2)}.json"
        when "Heading"
          "/v2/headings/#{gnid.first(4)}.json"
        when "Commodity"
          "/v2/commodities/#{gnid.first(10)}.json"
        else
          "/v2/commodities/#{gnid.first(10)}.json"
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
            headers['Content-Type'] = 'text/csv'
            headers['Content-Disposition'] = "attachment; filename=#{@goods_nomenclatures_cache_key}.csv"
            render "api/v2/goods_nomenclatures/index"
          end
        end
      end

      def action
        {
          show_by_section: 'section',
          show_by_chapter: 'chapter',
          show_by_heading: 'heading',
          show_by_commodity: 'commodity'
        }[params[:action].to_sym]
      end

      def render_not_found
        serializer = TradeTariffBackend.error_serializer(request)
        render json: serializer.serialized_errors({ error: 'not found', url: request.url }), status: 404
      end

      def set_cache_key
        key_string = params[:position] || params[:chapter_id] || params[:heading_id] || nil
        render_not_found if key_string.nil?
        
        object_type = action
        render_not_found if object_type.nil?

        @goods_nomenclatures_cache_key = [
          'goods-nomenclatures-for',
          object_type,
          key_string,
          'as-of',
          actual_date
        ].join('-')
      end
    end
  end
end
