class CdsImporter
  class EntityMapper
    def initialize(entity)
      @entity = entity
    end

    def parse
      klass = "#{self.class}::#{@entity.name}Mapper"
      if Object.const_defined?(klass)
        klass.constantize.new(@entity.values).parse
      else
        raise ArgumentError.new("Mapper class is undefined: #{klass}")
      end
    end
  end
end
