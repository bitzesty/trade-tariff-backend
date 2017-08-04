class CasNumberIndex < SearchIndex
  def definition
    {
      mappings: {
        cas_number: {
          properties: {
            title: { analyzer: "snowball", type: "string" },
            chapter: {
              type: "nested",
              properties: {
                description: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                producline_suffix: { type: "string" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "string" }
              }
            },
            heading: {
              type: "nested",
              properties: {
                number_indents: { type: "long" },
                description: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                producline_suffix: { type: "string" },
                goods_nomenclature_sid: { type: "long" },
                goods_nomenclature_item_id: { type: "string" }
              }
            },
            commodities: {
              type: "nested",
              properties: {
                id: { type: "long" },
                goods_nomenclature_item_id: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                validity_end_date: { format: "dateOptionalTime", type: "date" },
                number_indents: { type: "long" },
                description: { analyzer: "snowball", type: "string" },
                producline_suffix: { type: "string" }
              }
            }
          }
        }
      }
    }
  end
end
