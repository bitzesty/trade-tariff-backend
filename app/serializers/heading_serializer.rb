class HeadingSerializer < Serializer
  def serializable_hash(opts = {})
    heading_attributes = {
      id: goods_nomenclature_sid,
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      producline_suffix: producline_suffix,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: formatted_description,
      number_indents: number_indents,
    }

    if chapter.present?
      heading_attributes.merge!({
        chapter: {
          goods_nomenclature_sid: chapter.goods_nomenclature_sid,
          goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
          producline_suffix: chapter.producline_suffix,
          validity_start_date: chapter.validity_start_date,
          validity_end_date: chapter.validity_end_date,
          description: chapter.formatted_description
        }
      })

      if section.present?
        heading_attributes.merge!({
          section: {
            numeral: section.numeral,
            title: section.title,
            position: section.position
          }
        })
      end
    end

    heading_attributes
  end
end
