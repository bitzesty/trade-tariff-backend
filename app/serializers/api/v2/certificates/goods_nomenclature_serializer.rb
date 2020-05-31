module Api
  module V2
    module Certificates
      class GoodsNomenclatureSerializer
        include FastJsonapi::ObjectSerializer

        set_type :goods_nomenclature
        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :goods_nomenclature_sid, :producline_suffix, :number_indents
        attribute :description, &:formatted_description
      end
    end
  end
end
