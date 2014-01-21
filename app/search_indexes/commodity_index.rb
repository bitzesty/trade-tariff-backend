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
                description: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                producline_suffix: { type: "string" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "string" }
              }
            },
            validity_end_date: { format: "dateOptionalTime", type: "date" },
            number_indents: { type: "long" },
            description: { analyzer: "snowball", type: "string" },
            validity_start_date: { format: "dateOptionalTime", type: "date" },
            producline_suffix: { type: "string" },
            goods_nomenclature_item_id: { type: "string" },
            section: {
              dynamic: true,
              properties: {
                position: { type: "long" },
                title: { type: "string" },
                numeral: { type: "string" }
              }
            },
            heading: {
              dynamic: true,
              properties: {
                validity_end_date: { format: "dateOptionalTime", type: "date" },
                number_indents: { type: "long" },
                description: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                producline_suffix: { type: "string" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "string" }
              }
            }
          }
        }
      }
    }
  end
end
