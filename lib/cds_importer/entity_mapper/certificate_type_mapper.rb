class CdsImporter
  class EntityMapper
    class CertificateTypeMapper < BaseMapper
      self.entity_class = "CertificateType".freeze

      self.entity_mapping = BASE_MAPPING.merge(
        "certificateTypeCode" => :certificate_type_code
      ).freeze
    end
  end
end
