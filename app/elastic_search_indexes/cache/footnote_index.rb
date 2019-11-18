module Cache
  class FootnoteIndex < ::Cache::CacheIndex
    def definition
      {
        mappings: {
          footnote: {
            dynamic: false,
            properties: {
              footnote_id: { type: 'keyword' },
              footnote_type_id: { type: 'keyword' },
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
