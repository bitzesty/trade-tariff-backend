class NilClassSerializer < Serializer
  def serializable_hash(*)
    {}
  end
end
