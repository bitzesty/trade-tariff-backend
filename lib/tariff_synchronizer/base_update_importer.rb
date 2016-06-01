module TariffSynchronizer
  class BaseUpdateImporter
    def self.perform(base_update)
      new(base_update).apply
    end

    def initialize(base_update)
      @base_update = base_update
      @database_queries = RingBuffer.new(10)
    end

    def apply
      return unless @base_update.pending?
      track_latest_sql_queries
      keep_record_of_conformance_errors

      Sequel::Model.db.transaction(reraise: true) do
        # If a error is raised during import, mark the update as failed
        Sequel::Model.db.after_rollback { @base_update.mark_as_failed }
        @base_update.import!
      end
    rescue => e
      e = e.original if e.respond_to?(:original) && e.original
      persist_exception_for_review(e)
      notify_exception(e)
      raise Sequel::Rollback
    ensure
      ActiveSupport::Notifications.unsubscribe(@sql_subscriber)
      ActiveSupport::Notifications.unsubscribe(@conformance_errors_subscriber)
    end

    private

    def track_latest_sql_queries
      @sql_subscriber = ActiveSupport::Notifications.subscribe(/sql\.sequel/) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)

        binds = unless event.payload.fetch(:binds, []).blank?
                  event.payload[:binds].map do |column, value|
                    [column.name, value]
                  end.inspect
                end

        @database_queries.push(
          format("(%{class_name}) %{sql} %{binds}",
                 class_name: event.payload[:name],
                 sql: event.payload[:sql].squeeze(" "),
                 binds: binds))
      end
    end

    def keep_record_of_conformance_errors
      @conformance_errors_subscriber = ActiveSupport::Notifications.subscribe(/conformance_error/) do |*args|
        record = ActiveSupport::Notifications::Event.new(*args).payload[:record]
        TariffUpdateConformanceError.create(
          base_update: @base_update,
          model_name: record.class.to_s,
          model_primary_key: record.pk,
          model_values: record.values,
          model_conformance_errors: record.conformance_errors
        )
      end
    end

    def persist_exception_for_review(e)
      @base_update.update(exception_class: e.class.to_s + ": " + e.message.to_s,
                          exception_backtrace: e.backtrace.join("\n"),
                          exception_queries: @database_queries.join("\n"))
    end

    def notify_exception(exception)
      ActiveSupport::Notifications.instrument(
        "failed_update.tariff_synchronizer",
        exception: exception,
        update: @base_update,
        database_queries: @database_queries)
    end
  end
end
