module Cache
  class AdditionalCodeSerializer
    attr_reader :additional_code

    def initialize(additional_code)
      @additional_code = additional_code
    end

    def as_json
      {
        additional_code_sid: additional_code.additional_code_sid,
        code: additional_code.code,
        additional_code_type_id: additional_code.additional_code_type_id,
        additional_code: additional_code.additional_code,
        description: additional_code.description,
        formatted_description: additional_code.formatted_description,
        validity_start_date: additional_code.validity_start_date,
        validity_end_date: additional_code.validity_end_date,
        measures: additional_code.measures.map do |measure|
          {
            id: measure.measure_sid,
            measure_sid: measure.measure_sid,
            validity_start_date: measure.validity_start_date,
            validity_end_date: measure.validity_end_date,
            goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
            goods_nomenclature_sid: measure.goods_nomenclature_sid,
            goods_nomenclature: goods_nomenclature_attributes(measure)
          }
        end
      }
    end

    def goods_nomenclature_attributes(measure)
      return nil unless measure.goods_nomenclature.present?

      {
        goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
        goods_nomenclature_sid: measure.goods_nomenclature_sid,
        number_indents: measure.goods_nomenclature.number_indents,
        formatted_description: measure.goods_nomenclature.formatted_description,
        producline_suffix: measure.goods_nomenclature.producline_suffix,
        validity_start_date: measure.goods_nomenclature.validity_start_date,
        validity_end_date: measure.goods_nomenclature.validity_end_date
      }
    end
  end
end
