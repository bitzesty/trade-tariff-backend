class CommoditySerializer < Serializer
  def serializable_hash(opts = {})
    commodity_attributes = {
      id: goods_nomenclature_sid,
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      producline_suffix: producline_suffix,
      validity_start_date: validity_start_date,
      validity_end_date: validity_end_date,
      description: formatted_description,
      number_indents: number_indents,
    }

    if heading.present?
      commodity_attributes.merge!({
        heading: {
          goods_nomenclature_sid: heading.goods_nomenclature_sid,
          goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
          producline_suffix: heading.producline_suffix,
          validity_start_date: heading.validity_start_date,
          validity_end_date: heading.validity_end_date,
          description: heading.formatted_description,
          number_indents: heading.number_indents
        }
      })

      if chapter.present?
        commodity_attributes.merge!({
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
          commodity_attributes.merge!({
            section: {
              numeral: section.numeral,
              title: section.title,
              position: section.position
            }
          })
        end
      end
    end

    commodity_attributes
  end
end
