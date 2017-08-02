class CasNumberSerializer < Serializer
  def serializable_hash(opts = {})
    references = __getobj__.references

    if references.empty?
      {}
    else
      {
        title: title,
        references: references.map do |r|
          s = TradeTariffBackend.model_serializer_for(r.class).new(r)
          s.serializable_hash.merge({class: r.class})
        end
      }
    end
  end
end
