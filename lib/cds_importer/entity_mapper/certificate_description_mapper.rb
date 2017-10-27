#
# There is no collection with CertificateDescriptions in new xml.
# CertificateDescription is nested in to CertificateDescriptionPeriod,
# and certificateDescriptionPeriod is nested in to Certificate xml object.
# also CertificateDescription has attributes which are not present in CertificateDescription xml object
# e.g. 'certificate_description_period_sid' - present in parent object
# So we will pass @values for CertificateDescription the same as for Certificate.
#

class CdsImporter
  class EntityMapper
    class CertificateDescriptionMapper < BaseMapper
      self.mapping_path = "certificateDescriptionPeriod.certificateDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_class = "CertificateDescription".freeze

      self.entity_mapping = base_mapping.merge(
        "certificateDescriptionPeriod.sid" => :certificate_description_period_sid,
        "certificateDescriptionPeriod.certificateDescription.language.languageId" => :language_id,
        "certificateType.certificateTypeCode" => :certificate_type_code,
        "certificateCode" => :certificate_code,
        "certificateDescriptionPeriod.certificateDescription.description" => :description
      ).freeze
    end
  end
end
