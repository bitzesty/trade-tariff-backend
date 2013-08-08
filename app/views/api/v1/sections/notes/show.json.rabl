object @section_note

attributes :id, :section_id, :content

child(:section) {
  attributes :position, :title, :numeral, :chapter_from, :chapter_to
}
