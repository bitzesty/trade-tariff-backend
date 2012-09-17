class ChiefImporter
  class ChangeEntry
    attr_accessor :table, :strategy

    delegate :process!, to: :strategy

    def initialize(attributes = [])
      self.table = attributes[0].strip
      self.strategy = strategy_for(table).new(attributes.from(1)) if relevant?
    end

    def relevant?
      table.in?(ChiefImporter.relevant_tables)
    end

    private

    def strategy_for(table)
      "ChiefImporter::Strategies::#{table}".classify.constantize
    end
  end
end
