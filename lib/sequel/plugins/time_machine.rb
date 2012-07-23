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

        def point_in_time
          Thread.current[::TimeMachine::THREAD_DATETIME_KEY] || Date.today
        end

        def strategy
          Thread.current[::TimeMachine::THREAD_STRATEGY_KEY] || :relevant
        end

      end

      module InstanceMethods
        def actual(assoc)
          klass = assoc.to_s.classify.constantize

          case self.class.strategy
          when :absolute
            klass.where("#{self.class.table_name}.#{self.class.period_start_date_column} <= ? AND (#{self.class.table_name}.#{self.class.period_end_date_column} >= ? OR #{self.class.table_name}.#{self.class.period_end_date_column} IS NULL)", self.class.point_in_time, self.class.point_in_time)
          else # relevant
            klass.where("#{klass.table_name}.#{self.class.period_start_date_column} <= ? AND (#{klass.table_name}.#{self.class.period_end_date_column} >= ? OR #{klass.table_name}.#{self.class.period_end_date_column} IS NULL)", validity_start_date, validity_end_date)
          end
        end
        private :actual
      end
    end
  end
end
