collection @search_references

attributes :id, :title, :referenced_id, :referenced_class

node :referenced do |s|
  # use serializers:
  # ChapterSerializer, CommoditySerializer,
  # HeadingSerializer, SectionSerializer
  serializer_klass = "#{s.referenced_class}Serializer".constantize
  serializer_klass.new(s.referenced).serializable_hash
end
