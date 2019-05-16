module Search
  class NilClassSerializer < ::Serializer
    def serializable_hash(*)
      {}
    end
  end
end
