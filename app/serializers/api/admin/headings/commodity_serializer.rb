module Api
  module Admin
    module Headings
      class CommoditySerializer
        include FastJsonapi::ObjectSerializer

        set_type :commodity

        set_id :goods_nomenclature_sid

        attributes :description, :goods_nomenclature_item_id, :goods_nomenclature_sid

        attribute :search_references_count do |commodity|
          commodity.search_references.count
        end

        attribute :leaf do |object|
          object.producline_suffix == '80'
        end
      end
    end
  end
end
