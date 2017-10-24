
#
# CertificateTypeDescription is nested in to CertificateType
# CertificateTypeDescription has attributes which are not present in CertificateTypeDescription xml object
# e.g. 'certificate_type_code' - present in parent object
# So we will pass @values CertificateTypeDescription the same as for CertificateType
#

class CdsImporter
  class EntityMapper
    class CertificateTypeDescriptionMapper < BaseMapper
      class << self
        attr_accessor :mapping_path, :exclude_mapping

        def base_mapping
          BASE_MAPPING.except(exclude_mapping).keys.inject({}) do |memo, key|
            memo["#{mapping_path}.#{key}"] = BASE_MAPPING[key]
            memo
          end
        end
      end

      self.mapping_path = "certificateTypeDescription".freeze

      self.exclude_mapping = ["validityStartDate", "validityEndDate"].freeze

      self.entity_class = "CertificateTypeDescription".freeze

      self.entity_mapping = base_mapping.merge(
        "certificateTypeCode" => :certificate_type_code,
        "certificateTypeDescription.language.languageId" => :language_id,
        "certificateTypeDescription.description" => :description
      ).freeze
    end
  end
end
