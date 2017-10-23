class CdsImporter
  class EntityMapper
    class CertificateMapper < BaseMapper
      KLASS = "Certificate".freeze
      MAPPING = {
        "certificateType.certificateTypeCode" => :certificate_type_code,
        "certificateCode" => :certificate_code
      }.merge(BASE_MAPPING).freeze
    end
  end
end
