module Api
  module V2
    module Chapters
      class ChapterListSerializer
        include FastJsonapi::ObjectSerializer

        set_type :chapter

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id
      end
    end
  end
end
