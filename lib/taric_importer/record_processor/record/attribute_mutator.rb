class TaricImporter < TariffImporter
  class RecordProcessor
    class Record
      class AttributeMutator
        def self.mutate(attributes)
          # noop, pass through
          attributes
        end
      end
    end
  end
end
