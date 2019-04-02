module Api
  module V2
    module Headings
      class CommodityPresenter < SimpleDelegator

        attr_reader :commodity, :overview_measures_indexed

        def initialize(commodity)
          super(commodity)
          @commodity = commodity
          @overview_measures_indexed = commodity.overview_measures_indexed.map do |measure|
            Api::V2::Measures::MeasurePresenter.new(measure, commodity)
          end
        end

        def overview_measures_indexed_ids
          overview_measures_indexed.map(&:measure_sid)
        end

      end
    end
  end
end