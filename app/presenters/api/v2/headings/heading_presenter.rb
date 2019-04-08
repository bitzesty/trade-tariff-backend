module Api
  module V2
    module Headings
      class HeadingPresenter < SimpleDelegator

        attr_reader :heading, :commodities, :cache_key

        def initialize(heading, commodities, cache_key)
          super(heading)
          @heading = heading
          @commodities = commodities.map do |commodity|
            Api::V2::Headings::CommodityPresenter.new(commodity)
          end
          @cache_key = cache_key
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