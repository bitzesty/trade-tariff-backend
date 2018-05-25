class CdsImporter
  class EntityMapper
    def initialize(key, values)
      @key = key
      @values = values
    end

    def import
      mappers = CdsImporter::EntityMapper::BaseMapper.descendants.select{ |k| k.mapping_root == @key }
      mappers.each do |mapper|
        instance = mapper.new(@values).parse
        instance.save
      end
    end
  end
end
