module Api
  module V2
    module Commodities
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer

        set_type :heading

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_item_id, :description, :formatted_description,
                   :description_plain
      end
    end
  end
end
