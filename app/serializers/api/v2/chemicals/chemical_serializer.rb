module Api
  module V2
    module Chemicals
      class ChemicalSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chemical

        set_id :id

        attributes :id, :cas
        attribute :name, &:name

        has_many :goods_nomenclatures, serializer: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer
      end
    end
  end
end
