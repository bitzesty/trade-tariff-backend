class CdsImporter
  class EntityMapper
    def initialize(key, values)
      @key = key
      @values = values
    end

    def import
      mappers = CdsImporter::EntityMapper::BaseMapper.descendants
                                                     .select  { |m| m.mapping_root == @key }
                                                     .sort_by { |m| m.to_s.length }
      mappers.each do |mapper|
        instances = mapper.new(@values).parse
        instances.each { |i| i.save }
      end
    end
  end
end
