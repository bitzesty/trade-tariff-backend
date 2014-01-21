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
            title: { analyzer: "snowball", type: "string" },
            numeral: { type: "string" }
          }
        }
      }
    }
  end
end
