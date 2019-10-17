module Cache
  class AdditionalCodeIndex < ::Cache::CacheIndex
    def definition
      {
        mappings: {
          additional_code: {
            dynamic: false,
            properties: {
              additional_code: { type: 'keyword' },
              additional_code_type_id: { type: 'keyword' },
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
