class TaricImporter < TariffImporter
  class RecordProcessor
    class CreateOperation < Operation
      def call
        klass.create(attributes)
      end

      def to_oplog_operation
        :create
      end
    end
  end
end
