class ChapterSerializer < Serializer
  def serializable_hash(opts = {})
    chapter_attributes = {
      id: goods_nomenclature_sid,
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      producline_suffix: producline_suffix,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: formatted_description
    }

    if section.present?
      chapter_attributes.merge!({
        section: {
          numeral: section.numeral,
          title: section.title,
          position: section.position
        }
      })
    end

    chapter_attributes
  end
end
