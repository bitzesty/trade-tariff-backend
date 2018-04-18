class CdsImporter
  class EntityMapper
    def self.exist?(mapper_name)
      klass = "#{mapper_name.camelize}Mapper"
      !!CdsImporter::EntityMapper.const_get("#{klass}") rescue false
    end

    def initialize(entity)
      @entity = entity
    end

    def parse
      klass = "#{self.name}::#{@entity.name}Mapper"
      if Object.const_defined?(klass)
        klass.constantize.new(@entity.values).parse
      else
        raise ArgumentError.new("Mapper class is undefined: #{klass}")
      end
    end
  end
end
