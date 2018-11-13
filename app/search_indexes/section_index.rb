class SectionIndex < SearchIndex
  def goods_nomenclature?
    true
  end

  def definition
    {
      mappings: {
        section: {
          properties: {
            position: { type: "long" },
            id: { type: "long" },
            title: { type: "text" , analyzer: "snowball" },
            numeral: { type: "keyword" }
          }
        }
      }
    }
  end
end
