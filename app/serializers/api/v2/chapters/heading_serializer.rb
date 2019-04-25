module Api
  module V2
    module Chapters
      class HeadingSerializer
        include FastJsonapi::ObjectSerializer

        set_type :heading

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id,
                   :declarable, :description, :producline_suffix, :leaf,
                   :description_plain, :formatted_description
      end
    end
  end
end
