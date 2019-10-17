module Cache
  class CertificateIndex < ::Cache::CacheIndex
    def definition
      {
        mappings: {
          certificate: {
            dynamic: false,
            properties: {
              certificate_code: { type: 'keyword' },
              certificate_type_code: { type: 'keyword' },
              description: { type: 'text', analyzer: 'snowball' },
              validity_start_date: { type: "date", format: "dateOptionalTime" },
              validity_end_date: { type: "date", format: "dateOptionalTime" },
            }
          }
        }
      }
    end
  end
end
