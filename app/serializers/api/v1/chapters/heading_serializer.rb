module Api
  module V1
    module Chapters
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :heading
        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id,
                   :declarable, :description, :producline_suffix, :leaf,
                   :description_plain, :formatted_description
      end
    end
  end
end