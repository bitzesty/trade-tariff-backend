module Api
  module V2
    module GoodsNomenclatures
      class GoodsNomenclatureListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :goods_nomenclature
        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :goods_nomenclature_sid, :description, :number_indents
        attribute :productline_suffix, &:producline_suffix
        attribute :href do |c|
          GoodsNomenclaturesController.api_path_builder(c)
        end
      end
    end
  end
end
