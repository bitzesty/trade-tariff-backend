class CasNumberSerializer < Serializer
  def serializable_hash(opts = {})
    chapter = __getobj__.chapter
    heading = __getobj__.heading
    commodities = __getobj__.commodities

    if chapter.nil? || heading.nil?
      {}
    else
      {
        title: title,
        chapter: {
          id: chapter.goods_nomenclature_sid,
          goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
          producline_suffix: chapter.producline_suffix,
          validity_start_date: chapter.validity_start_date,
          validity_end_date: chapter.validity_end_date,
          description: chapter.formatted_description
        },
        heading: {
          id: heading.goods_nomenclature_sid,
          goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
          producline_suffix: heading.producline_suffix,
          validity_start_date: heading.validity_start_date,
          validity_end_date: heading.validity_end_date,
          description: heading.formatted_description,
          number_indents: heading.number_indents
        },
        commodities: commodities.map do |c|
          {
            id: c.goods_nomenclature_sid,
            goods_nomenclature_item_id: c.goods_nomenclature_item_id,
            producline_suffix: c.producline_suffix,
            validity_start_date: c.validity_start_date,
            validity_end_date: c.validity_end_date,
            description: c.formatted_description,
            number_indents: c.number_indents
          }
        end
      }
    end
  end
end
