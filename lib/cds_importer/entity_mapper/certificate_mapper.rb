class CdsImporter
  class EntityMapper
    class CertificateMapper < BaseMapper
      self.entity_class = "Certificate".freeze
      self.entity_mapping = BASE_MAPPING.merge(
        "certificateType.certificateTypeCode" => :certificate_type_code,
        "certificateCode" => :certificate_code
      ).freeze
    end
  end
end
