module Search
  class ChapterIndex < ::SearchIndex
    def goods_nomenclature?
      true
    end
    
    def definition
      {
        mappings: {
          chapter: {
            properties: {
              id: {type: 'long'},
              description: {type: 'text', analyzer: 'snowball'},
              validity_start_date: {type: 'date', format: 'dateOptionalTime'},
              producline_suffix: {type: 'keyword'},
              goods_nomenclature_item_id: {type: 'keyword'},
              section: {
                dynamic: true,
                properties: {
                  position: {type: 'long'},
                  title: {type: 'text'},
                  numeral: {type: 'keyword'}
                }
              }
            }
          }
        }
      }
    end
  end
end
