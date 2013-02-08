class ChiefTransformer
  class Processor
    class Operation
      attr_reader :record, :operation_date

      def initialize(record)
        @record = record
        @operation_date = record.operation_date
      end
    end
  end
end
