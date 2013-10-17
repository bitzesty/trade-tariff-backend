class TaricImporter < TariffImporter
  class RecordProcessor
    class DestroyOperation < Operation
      def call
        model = klass.filter(attributes.slice(*primary_key).symbolize_keys).take
        model.set(attributes.except(*primary_key).symbolize_keys)
        model.destroy
        model
      end

      def to_oplog_operation
        :destroy
      end
    end
  end
end
