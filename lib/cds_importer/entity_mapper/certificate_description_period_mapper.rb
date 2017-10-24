#
# CertificateDescriptionPeriod has attributes which are not present in CertificateDescriptionPeriod xml object
# e.g. 'certificate_type_code' - present in parent object
# So we will pass @values CertificateDescriptionPeriod the same as for Certificate
#

class CdsImporter
  class EntityMapper
    class CertificateDescriptionPeriodMapper < BaseMapper
      self.mapping_path = "certificateDescriptionPeriod".freeze

      self.entity_class = "CertificateDescriptionPeriod".freeze

      self.entity_mapping = base_mapping.merge(
        "certificateDescriptionPeriod.sid" => :certificate_description_period_sid,
        "certificateType.certificateTypeCode" => :certificate_type_code,
        "certificateCode" => :certificate_code
      ).freeze
    end
  end
end
