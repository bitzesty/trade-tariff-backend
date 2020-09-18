module Api
  module Admin
    module Chapters
      class HeadingSerializer
        include JSONAPI::Serializer

        set_type :heading

        set_id :goods_nomenclature_sid

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :declarable, :description

        attribute :search_references_count do |heading|
          heading.search_references.count
        end
      end
    end
  end
end
