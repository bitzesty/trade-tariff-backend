module Api
  module V2
    module Headings
      class HeadingPresenter < SimpleDelegator
        attr_reader :heading, :commodities

        def initialize(heading, commodities)
          super(heading)
          @heading = heading
          @commodities = commodities.map do |commodity|
            Api::V2::Headings::CommodityPresenter.new(commodity)
          end
        end

        def commodity_ids
          commodities.map(&:goods_nomenclature_sid)
        end

        def chapter_id
          heading.chapter.goods_nomenclature_sid
        end
      end
    end
  end
end
