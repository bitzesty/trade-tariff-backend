require "cds_importer/entity_mapper/additional_code_mapper"

class CdsImporter
  class EntityMapper
    def initialize(entity)
      @entity = entity
    end

    def parse
      klass = "#{self.class}::#{@entity.name}Mapper"
      klass.constantize.new(@entity.values).parse
    end
  end
end
