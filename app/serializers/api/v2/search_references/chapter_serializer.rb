module Api
  module V2
    module SearchReferences
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :chapter

        attributes :goods_nomenclature_item_id, :producline_suffix, :validity_start_date,
                   :validity_end_date, :description

        has_many :guides, serializer: Api::V2::GuideSerializer
        has_one :section, serializer: Api::V2::SearchReferences::SectionSerializer

      end
    end
  end
end