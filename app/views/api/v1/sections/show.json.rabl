object @section
attributes :position, :title, :numeral
node(:section_note, if: lambda {|section| section.section_note.present? }) do |section|
  section.section_note.content
end
child(chapters: :chapters) do
  attributes :description, :goods_nomenclature_item_id
end
