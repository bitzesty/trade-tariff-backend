module Api
  module V2
    module Certificates
      class GoodsNomenclatureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :goods_nomenclature
        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :goods_nomenclature_sid, :description, :number_indents
        attribute :productline_suffix, &:producline_suffix
      end
    end
  end
end