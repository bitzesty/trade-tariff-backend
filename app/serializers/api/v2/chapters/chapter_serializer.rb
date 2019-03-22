module Api
  module V2
    module Chapters
      class ChapterSerializer
        include FastJsonapi::ObjectSerializer
        set_id :goods_nomenclature_sid
        set_type :chapter

        attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :description, :formatted_description
        attribute :chapter_note_id do |chapter|
          chapter.chapter_note.try(:id)
        end
        attribute :chapter_note, if: Proc.new { |chapter| chapter.chapter_note.present? } do |chapter|
          chapter.chapter_note.content
        end

        attribute :section_id do |chapter|
          chapter.section.id
        end

        has_one :section, serializer: Api::V2::Chapters::SectionSerializer
        has_many :guides, serializer: Api::V2::GuideSerializer
        has_many :headings, serializer: Api::V2::Chapters::HeadingSerializer

      end
    end
  end
end