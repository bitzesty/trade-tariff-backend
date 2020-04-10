module Api
  module V2
    module Chemicals
      class ChemicalListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chemical

        set_id :id

        attributes :id, :cas
        attribute :name, &:name

        has_many :goods_nomenclatures, serializer: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer
        has_many :chemical_names, serializer: Api::V2::Chemicals::ChemicalNameSerializer
      end
    end
  end
end
