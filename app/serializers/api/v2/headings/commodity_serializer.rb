module Api
  module V2
    module Headings
      class CommoditySerializer
        include FastJsonapi::ObjectSerializer

        set_type :commodity

        set_id :goods_nomenclature_sid

        attributes :description, :number_indents, :goods_nomenclature_item_id, :leaf,
                   :goods_nomenclature_sid, :formatted_description, :description_plain,
                   :producline_suffix

        attribute :parent_sid do |commodity|
          commodity.parent.try(:goods_nomenclature_sid)
        end

        attribute :search_references_count do |commodity|
          commodity.search_references.count
        end

        has_many :overview_measures_indexed, key: :overview_measures, record_type: :measure,
                 serializer: Api::V2::Measures::OverviewMeasureSerializer

      end
    end
  end
end
