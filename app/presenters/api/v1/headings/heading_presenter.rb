module Api
  module V1
    module Headings
      class HeadingPresenter

        attr_reader :heading, :commodities, :cache_key

        delegate :goods_nomenclature_sid, :goods_nomenclature_item_id, :description, :bti_url,
                 :formatted_description,
                 :footnote_ids, :section_id, :chapter_id, :chapter, :section, :footnotes,
                 to: :heading

        def initialize(heading, commodities, cache_key)
          @heading = heading
          @commodities = commodities.map do |commodity|
            Api::V1::Headings::CommodityPresenter.new(commodity)
          end
          @cache_key = cache_key
        end

        def commodity_ids
          commodities.map(&:goods_nomenclature_sid)
        end

      end
    end
  end
end