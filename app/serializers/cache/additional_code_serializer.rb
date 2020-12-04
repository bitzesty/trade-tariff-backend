module Cache
  class AdditionalCodeSerializer
    include ::Cache::SearchCacheMethods

    attr_reader :additional_code, :as_of

    def initialize(additional_code)
      @additional_code = additional_code
      @as_of = Date.current.midnight
    end

    def as_json
      measures = additional_code.measures.select do |measure|
        has_valid_dates(measure, :effective_start_date, :effective_end_date)
      end
      {
        additional_code_sid: additional_code.additional_code_sid,
        code: additional_code.code,
        additional_code_type_id: additional_code.additional_code_type_id,
        additional_code: additional_code.additional_code,
        description: additional_code.description,
        formatted_description: additional_code.formatted_description,
        validity_start_date: additional_code.validity_start_date,
        validity_end_date: additional_code.validity_end_date,
        measure_ids: measures.map(&:measure_sid),
        measures: measures.map do |measure|
          {
            id: measure.measure_sid,
            measure_sid: measure.measure_sid,
            validity_start_date: measure.validity_start_date,
            effective_start_date: measure.effective_start_date,
            validity_end_date: measure.validity_end_date,
            effective_end_date: measure.effective_end_date,
            goods_nomenclature_item_id: measure.goods_nomenclature_item_id,
            goods_nomenclature_sid: measure.goods_nomenclature_sid,
            goods_nomenclature: goods_nomenclature_attributes(measure.goods_nomenclature)
          }
        end
      }
    end
  end
end
