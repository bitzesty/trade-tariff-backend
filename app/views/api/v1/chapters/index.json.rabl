collection @chapters
attributes :goods_nomenclature_item_id
node(:chapter_note_id) { |chapter| chapter.chapter_note.try(:id) }
