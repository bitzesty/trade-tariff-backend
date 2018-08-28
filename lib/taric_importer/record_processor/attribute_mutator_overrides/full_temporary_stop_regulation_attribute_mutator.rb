class TaricImporter
  class RecordProcessor
    class FullTemporaryStopRegulationAttributeMutator < TaricImporter::RecordProcessor::AttributeMutator

      def self.mutate(attributes)
        attributes['effective_end_date'] = attributes.delete('effective_enddate')
        attributes
      end

    end
  end
end
