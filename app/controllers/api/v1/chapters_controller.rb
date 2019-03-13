require 'goods_nomenclature_mapper'

module Api
  module V1
    class ChaptersController < ApiController
      before_action :find_chapter, only: [:show, :changes]

      def index
        @chapters = Chapter.eager(:chapter_note).all

        render json: Api::V1::Chapters::ChapterListSerializer.new(@chapters).serializable_hash
      end

      def show
        headings_presenter = GoodsNomenclatureMapper.new(@chapter.headings_dataset
                                                        .eager(:goods_nomenclature_descriptions,
                                                               :goods_nomenclature_indents)
                                                        .all).root_entries

        options = {}
        options[:include] = [:section, :guides, :headings]
        presenter = Api::V1::Chapters::ChapterPresenter.new(@chapter, headings_presenter)
        render json: Api::V1::Chapters::ChapterSerializer.new(presenter, options).serializable_hash
      end

      def changes
        key = "chapter-#{@chapter.goods_nomenclature_sid}-#{actual_date}-#{TradeTariffBackend.currency}/changes"
        @changes = Rails.cache.fetch(key, expires_at: actual_date.end_of_day) do
          ChangeLog.new(@chapter.changes.where { |o|
            o.operation_date <= actual_date
          })
        end

        options = {}
        options[:include] = [:record, 'record.geographical_area', 'record.measure_type']
        render json: Api::V1::Changes::ChangeSerializer.new(@changes.changes, options).serializable_hash
      end

      private

      def find_chapter
        @chapter = Chapter.actual
                          .where(goods_nomenclature_item_id: chapter_id)
                          .take

        raise Sequel::RecordNotFound if @chapter.goods_nomenclature_item_id.in? HiddenGoodsNomenclature.codes
      end

      def chapter_id
        "#{params[:id]}00000000"
      end
    end
  end
end
