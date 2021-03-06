module Api
  module V2
    class NullSearchSerializer
      include JSONAPI::Serializer

      set_type :null_search

      attributes :type, :goods_nomenclature_match, :reference_match
    end
  end
end
