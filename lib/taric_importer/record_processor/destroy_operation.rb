class TaricImporter
  class RecordProcessor
    class DestroyOperation < Operation
      def call
        model = get_model_record
        return unless model
        model.set(attributes.except(*primary_key).symbolize_keys)
        model.destroy
        model
      end

      def to_oplog_operation
        :destroy
      end

      private

      # Sometimes destroy operations go in wrong order (not chronologically, e.g. 'destroy' operation goes before 'create').
      # We decided to have ability to not break import process:
      #   set env TARIFF_IGNORE_PRESENCE_ON_DESTROY=1 to ignore Sequel::RecordNotFound on destroy
      def get_model_record
        filters = attributes.slice(*primary_key).symbolize_keys
        if ignore_presence_on_destroy?
          model = klass.filter(filters).first
          log_destroy_error unless model
        else
          model = klass.filter(filters).take
        end
        model
      end

      def log_destroy_error
        attrs = record.attributes.merge(transaction_id: record.transaction_id, operation_date: @operation_date)
        instrument("destroy_error.taric_importer", klass: klass.to_s, attributes: attrs)
      end

      def ignore_presence_on_destroy?
        TariffSynchronizer.ignore_presence_on_destroy
      end
    end
  end
end
