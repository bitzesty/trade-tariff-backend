require "date"

module Sequel
  module Plugins
    module TimeMachine
      START_DATE_COLUMN_DEFAULT = :validity_start_date
      END_DATE_COLUMN_DEFAULT = :validity_end_date

      def self.configure(model, opts={})
        model.period_start_date_column = opts[:period_start_column].presence || START_DATE_COLUMN_DEFAULT
        model.period_end_date_column = opts[:period_end_column].presence || END_DATE_COLUMN_DEFAULT
      end

      module ClassMethods
        attr_accessor :period_start_date_column, :period_end_date_column

        # Inheriting classes have the same start/end date columns
        def inherited(subclass)
          super

          subclass.period_start_date_column = period_start_date_column
          subclass.period_end_date_column = period_end_date_column
        end

        def at(date = Date.today)
          Thread.current[::TimeMachine::THREAD_DATE_KEY] = date

          self
        end

        def point_in_time
          Thread.current[::TimeMachine::THREAD_DATE_KEY] || Date.today
        end

        def actual
          where("#{send(:period_start_date_column)} <= ? AND (#{send(:period_end_date_column)} >= ? OR #{send(:period_end_date_column)} IS NULL)", point_in_time, point_in_time)
        end
      end

      module InstanceMethods
        def point_in_time
          self.class.point_in_time
        end
      end
    end
  end
end
