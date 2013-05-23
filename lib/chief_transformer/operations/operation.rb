require 'forwardable'

class ChiefTransformer
  class Processor
    class Operation
      extend Forwardable

      def_delegator ActiveSupport::Notifications, :instrument

      attr_reader :record

      def initialize(record)
        @record = record
      end

      def update_record(record, attributes = {})
        record.set(attributes)

        unless record.valid?
          record.invalidated_at = Time.now

          instrument("invalidated.tariff_synchronizer", record: record)
        end

        record.save
      end
    end
  end
end
