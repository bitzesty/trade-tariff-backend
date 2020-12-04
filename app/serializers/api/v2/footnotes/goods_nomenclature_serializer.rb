module Api
  module V2
    module Footnotes
      class GoodsNomenclatureSerializer
        include JSONAPI::Serializer

        set_type :goods_nomenclature
        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :goods_nomenclature_sid, :producline_suffix, :number_indents
        attribute :description, &:formatted_description
      end
    end
  end
end
