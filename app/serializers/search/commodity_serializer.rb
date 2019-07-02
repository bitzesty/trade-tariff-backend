module Search
  class CommoditySerializer < ::Serializer
    def serializable_hash(_opts = {})
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
        commodity_attributes[:heading] = {
          goods_nomenclature_sid: heading.goods_nomenclature_sid,
          goods_nomenclature_item_id: heading.goods_nomenclature_item_id,
          producline_suffix: heading.producline_suffix,
          validity_start_date: heading.validity_start_date,
          validity_end_date: heading.validity_end_date,
          description: heading.formatted_description,
          number_indents: heading.number_indents
        }
        
        if chapter.present?
          commodity_attributes[:chapter] = {
            goods_nomenclature_sid: chapter.goods_nomenclature_sid,
            goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
            producline_suffix: chapter.producline_suffix,
            validity_start_date: chapter.validity_start_date,
            validity_end_date: chapter.validity_end_date,
            description: chapter.formatted_description,
            guides: chapter.guides.map do |guide|
              {
                title: guide.title,
                url: guide.url
              }
            end
          }
          
          if section.present?
            commodity_attributes[:section] = {
              numeral: section.numeral,
              title: section.title,
              position: section.position
            }
          end
          
          if overview_measures.present?
            commodity_attributes[:overview_measures] = overview_measures.map do |measure|
              components = components_for_measure(measure)
              
              measure_hash = {
                id: measure.id,
                goods_nomenclature_sid: measure.goods_nomenclature_sid,
                goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
                additional_code: measure.additional_code,
                measure_sid: measure.measure_sid,
                measure_type_id: measure.measure_type_id,
                effective_start_date: measure.effective_start_date,
                effective_end_date: measure.effective_end_date,
                vat?: measure.vat?,
                third_country?: measure.third_country?,
                measure_type: {
                  measure_type_id: measure.measure_type.measure_type_id,
                  description: measure.measure_type.description
                },
                duty_expression_with_national_measurement_units_for: measure.duty_expression_with_national_measurement_units_for(nil),
                formatted_duty_expression_with_national_measurement_units_for: measure.formatted_duty_expression_with_national_measurement_units_for(nil)
              }
              
              measure_hash.merge!(measure_components: components)
            end
          end
        end
      end
      
      commodity_attributes
    end
    
    def components_for_measure(measure)
      return [] unless measure.measure_components.present?
      
      measure.measure_components.map do |component|
        {
          duty_expression: component.duty_expression_description,
          measurement_unit: component.measurement_unit,
          monetary_unit: component.monetary_unit,
          formatted_duty_expression: component.formatted_duty_expression
        }
      end
    end
  end
end
