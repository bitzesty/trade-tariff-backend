module Api
  module V1
    module Headings
      class CommodityPresenter

        attr_reader :commodity, :overview_measures_indexed

        delegate :description, :number_indents, :goods_nomenclature_item_id, :leaf,
                 :goods_nomenclature_sid, :formatted_description, :description_plain,
                 :producline_suffix, :parent, :declarable?,
                 to: :commodity

        def initialize(commodity)
          @commodity = commodity
          @overview_measures_indexed = commodity.overview_measures_indexed.map do |measure|
            Api::V1::Measures::MeasurePresenter.new(measure, commodity)
          end
        end

        def overview_measures_indexed_ids
          overview_measures_indexed.map(&:measure_sid)
        end

      end
    end
  end
end