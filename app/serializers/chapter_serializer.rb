class ChapterSerializer
  include FastJsonapi::ObjectSerializer
  set_id :goods_nomenclature_sid
  attributes :goods_nomenclature_sid, :goods_nomenclature_item_id, :headings_from, :headings_to, :description, :formatted_description

  attribute :chapter_note_id do |chapter|
    chapter.chapter_note.try(:id)
  end

  has_many :guides, serializer: GuideSerializer

end
