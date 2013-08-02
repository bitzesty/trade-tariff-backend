require 'taric_importer/record_processor/attribute_mutator'

# Can also mutate attributes for all record operations, e.g.:
#
#  class LanguageAttributeMutator < AttributeMutator
#    def self.mutate(attributes)
#      attributes[:a] = 'b'
#      attributes   # do not forget to return it
#    end
#  end

Dir[File.join(Rails.root, 'lib', 'taric_importer', 'record_processor', 'attribute_mutator_overrides', '*.rb')].each {|file|
  require file
}

class TaricImporter < TariffImporter
  class RecordProcessor
    class Record
      include TaricImporter::Helpers::StringHelper

      # Entity class, e.g. Measure
      attr_accessor :klass

      # Entity primary key, i.e. Measure.primary_key
      attr_accessor :primary_key

      # Sanitized and processed attributes
      attr_reader :attributes

      # TARIC transaction ID
      attr_accessor :transaction_id

      def initialize(record_hash)
        self.transaction_id = record_hash['transaction.id']
        self.klass = as_strategy(record_hash.keys.last).constantize
        self.primary_key = [klass.primary_key].flatten.map(&:to_s)
        self.attributes = sanitize_attributes(record_hash.values.last)
      end

      def attributes=(attributes)
        attributes = mutate_attributes(attributes)

        @attributes = default_attributes.merge(attributes)
      end

      private

      def default_attributes
        klass.columns.inject({}) { |memo, column_name|
          memo.merge!(Hash[column_name.to_s, nil])
          memo
        }
      end

      def mutate_attributes(attributes)
        mutator_class = begin
                          "TaricImporter::RecordProcessor::#{klass}AttributeMutator".constantize
                        rescue NameError
                          TaricImporter::RecordProcessor::AttributeMutator
                        end

        mutator_class.mutate(attributes)
      end

      def sanitize_attributes(attributes)
        attributes.inject({}) { |memo, (key, value)|
          memo.merge!(Hash[as_param(key), value.strip]) unless value.blank?
          memo
        }
      end
    end
  end
end
