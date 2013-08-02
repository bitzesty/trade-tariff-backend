class TaricImporter < TariffImporter
  class RecordProcessor
    class Operation
      attr_reader :record

      delegate :primary_key, :klass, to: :record

      def initialize(record, operation_date)
        @record = record
        @operation_date = operation_date
      end

      # Taric operation adds date and operation type
      # for Oplog
      def attributes
        record.attributes.merge(
          'operation' => to_oplog_operation,
          'operation_date' => @operation_date
        )
      end

      def call
        raise NotImplementedError.new
      end

      def to_oplog_operation
        raise NotImplementedError.new
      end
    end
  end
end
