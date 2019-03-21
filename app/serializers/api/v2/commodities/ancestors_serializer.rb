module Api
  module V2
    module Commodities
      class AncestorsSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :commodity

        attributes :producline_suffix, :description, :number_indents, :goods_nomenclature_item_id,
                   :formatted_description, :description_plain
      end
    end
  end
end