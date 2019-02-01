class CommodityIndex < SearchIndex
  def goods_nomenclature?
    true
  end

  def definition
    {
      mappings: {
        commodity: {
          properties: {
            id: { type: "long" },
            chapter: {
              dynamic: true,
              properties: {
                description: { type: "text" },
                validity_start_date: { type: "date", format: "dateOptionalTime" },
                producline_suffix: { type: "keyword" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "keyword" }
              }
            },
            validity_end_date: { format: "dateOptionalTime", type: "date" },
            number_indents: { type: "long" },
            description: { type: "text", analyzer: "snowball" },
            validity_start_date: { type: "date", format: "dateOptionalTime" },
            producline_suffix: { type: "keyword" },
            goods_nomenclature_item_id: { type: "keyword" },
            section: {
              dynamic: true,
              properties: {
                position: { type: "long" },
                title: { type: "text" },
                numeral: { type: "keyword" }
              }
            },
            heading: {
              dynamic: true,
              properties: {
                validity_end_date: { type: "date", format: "dateOptionalTime" },
                number_indents: { type: "long" },
                description: { type: "text" },
                validity_start_date: { type: "date", format: "dateOptionalTime" },
                producline_suffix: { type: "keyword" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "keyword" }
              }
            },
            overview_measures: {
              dynamic: true,
              properties: {
                measure_sid: { type: "long" },
                measure_type_id: { type: "keyword" },
                effective_start_date: { format: "dateOptionalTime", type: "date" },
                effective_end_date: { format: "dateOptionalTime", type: "date" },
              }
            }
          }
        }
      }
    }
  end
end
