module Api
  module V2
    module Footnotes
      class GoodsNomenclatureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :goods_nomenclature
        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :goods_nomenclature_sid, :number_indents
        attribute :description, &:formatted_description
        attribute :productline_suffix, &:producline_suffix
      end
    end
  end
end
