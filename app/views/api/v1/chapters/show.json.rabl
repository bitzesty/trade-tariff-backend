object @chapter

attributes :goods_nomenclature_item_id, :description

child :section do
  attributes :title, :position, :numeral
end

node(:chapter_note, if: lambda {|chapter| chapter.chapter_note.present? }) do |chapter|
  chapter.chapter_note.content
end

node(:headings) do
  @headings.map do |heading|
    partial("api/v1/headings/heading", object: heading)
  end
end
