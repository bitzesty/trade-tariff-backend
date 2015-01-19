object @search_reference

attributes :id, :title, :referenced_id, :referenced_class

node :referenced do |s|
  # use serializers
  klass = "#{s.referenced_class}Serializer".constantize
  klass.new(s.referenced).serializable_hash
end
