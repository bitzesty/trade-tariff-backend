module Api
  module V2
    module Chemicals
      class ChemicalSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chemical

        set_id :id

        link :uri do |object|
          "/chemicals/#{object.cas}"
        end

        attributes :id, :cas
        attribute :name, &:name

        has_many :goods_nomenclatures, serializer: Api::V2::GoodsNomenclatures::GoodsNomenclatureListSerializer
        has_many :chemical_names
      end
    end
  end
end
