module Api
  module V2
    module Commodities
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :heading
        attributes :goods_nomenclature_item_id, :description, :formatted_description,
                   :description_plain
      end
    end
  end
end