class TaricImporter
  class RecordProcessor
    class UpdateOperation < Operation
      def call
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).take
        model.update(attributes.except(*primary_key).symbolize_keys)
        model
      end

      def to_oplog_operation
        :update
      end
    end
  end
end
