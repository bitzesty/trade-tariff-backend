module Api
  module V2
    class FuzzySearchSerializer
      include JSONAPI::Serializer

      set_type :fuzzy_search

      attributes :type, :goods_nomenclature_match, :reference_match
    end
  end
end
