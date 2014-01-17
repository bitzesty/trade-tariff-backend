class ChapterIndex < SearchIndex
  def goods_nomenclature?
    true
  end

  def definition
    {
      mappings: {
        chapter: {
          properties: {
            id: { type: 'long' },
            description: { type: 'string', analyzer: 'snowball' },
            validity_start_date: { type: 'date', format: 'dateOptionalTime' },
            producline_suffix: { type: 'string' },
            goods_nomenclature_item_id: { type: 'string' },
            section: {
              dynamic: true,
              properties: {
                position: { type: 'long' },
                title: { type: 'string' },
                numeral: { type: 'string' }
              }
            }
          }
        }
      }
    }
  end
end
