class ChiefTransformer
  class Processor
    class Operation
      attr_reader :record

      def initialize(record)
        @record = record
      end

      def update_record(record, attributes = {})
        record.set attributes
        record.invalidated_at = Time.now unless record.valid?
        record.save
      end
    end
  end
end
