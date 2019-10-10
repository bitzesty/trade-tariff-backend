module Cache
  class CertificateSerializer
    attr_reader :certificate

    def initialize(certificate)
      @certificate = certificate
    end

    def as_json
      {
        id: certificate.id,
        certificate_type_code: certificate.certificate_type_code,
        certificate_code: certificate.certificate_code,
        description: certificate.description,
        formatted_description: certificate.formatted_description,
        validity_start_date: certificate.validity_start_date,
        validity_end_date: certificate.validity_end_date,
        measures: certificate.measures.map do |measure|
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
