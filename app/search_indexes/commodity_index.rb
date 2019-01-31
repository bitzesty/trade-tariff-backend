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
                goods_nomenclature_sid: { type: "keyword" },
                additional_code: { type: "nested" },
                measure_sid: { type: "long" },
                measure_type_id: { type: "keyword" },
                vat?: { type: "boolean" },
                third_country?: { type: "boolean" },
                measure_type: {
                  type: "nested",
                  properties: {
                    description: { type: "text" },
                  }
                },
                duty_expression_with_national_measurement_units_for: { type: "text" },
                formatted_duty_expression_with_national_measurement_units_for: { type: "text" },
                measure_components: {
                  type: "nested",
                  properties: {
                    duty_expression: { type: "text" },
                    measurement_unit: { type: "nested" },
                    monetary_unit: { type: "nested" },
                    formatted_duty_expression: { type: "text" }
                  }
                },
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
