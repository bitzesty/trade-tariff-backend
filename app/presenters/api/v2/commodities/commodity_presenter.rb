module Api
  module V2
    module Commodities
      class CommodityPresenter < SimpleDelegator
        attr_reader :commodity, :footnotes, :import_measures, :export_measures, :cache_key

        def initialize(commodity, measures, cache_key)
          super(commodity)
          @commodity = commodity
          @footnotes = commodity.footnotes + commodity.heading.footnotes
          @import_measures = measures.select(&:import).map do |measure|
            Api::V2::Measures::MeasurePresenter.new(measure, commodity)
          end
          @export_measures = measures.select(&:export).map do |measure|
            Api::V2::Measures::MeasurePresenter.new(measure, commodity)
          end
          @cache_key = cache_key
        end

        def consigned
          commodity.consigned?
        end

        def footnote_ids
          footnotes.map(&:footnote_id)
        end

        def import_measure_ids
          import_measures.map(&:measure_sid)
        end

        def export_measure_ids
          export_measures.map(&:measure_sid)
        end

        def heading_id
          commodity.heading.goods_nomenclature_sid
        end

        def chapter_id
          commodity.chapter.goods_nomenclature_sid
        end

        def ancestor_ids
          commodity.ancestors.pluck(:goods_nomenclature_sid)
        end

        def meursing_code?
          import_measures.any?(&:meursing?) || export_measures.any?(&:meursing?)
        end
        alias meursing_code meursing_code?
      end
    end
  end
end
