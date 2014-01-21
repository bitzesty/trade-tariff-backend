class SectionSerializer < Serializer
  def serializable_hash(opts = {})
    {
      id: id,
      numeral: numeral,
      title: title,
      position: position
    }
  end
end
