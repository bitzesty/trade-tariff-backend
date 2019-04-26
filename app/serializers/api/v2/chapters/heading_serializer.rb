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
        
        has_many :children, record_type: 'heading', serializer: Api::V2::Chapters::HeadingLeafSerializer
      end
    end
  end
end
