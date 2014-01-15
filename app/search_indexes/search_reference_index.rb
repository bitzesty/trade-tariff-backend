class SearchReferenceIndex < SearchIndex
  def definition
    {
      mappings: {
        search_reference: {
          properties: {
            title: { analyzer: "snowball", type: "string" },
            reference_class: { type: "string" },
            reference: {
              properties: {
                position: { type: "long" },
                numeral: { type: "string" },
                validity_end_date: { format: "dateOptionalTime", type: "date" },
                class: { type: "string" },
                validity_start_date: { format: "dateOptionalTime", type: "date" },
                goods_nomenclature_item_id: { type: "string" },
                section: {
                  dynamic: true,
                  properties: {
                    position: { type: "long" },
                    title: { type: "string" },
                    numeral: { type: "string" }
                  }
                },
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
                title: { type: "string" },
                description: { type: "string" },
                number_indents: { type: "long" },
                producline_suffix: { type: "string" },
                heading: {
                  dynamic: true,
                  properties: {
                    number_indents: { type: "long" },
                    description: { type: "string" },
                    validity_start_date: { format: "dateOptionalTime", type: "date" },
                    producline_suffix: { type: "string" },
                    goods_nomenclature_sid: { type: "long" },
                    goods_nomenclature_item_id: { type: "string" }
                  }
                }
              },
              type: "nested"
            }
          }
        }
      }
    }
  end
end
