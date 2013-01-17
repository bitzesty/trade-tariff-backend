require 'date'

module Sequel
  module Plugins
    module TimeMachine
      def self.configure(model, opts={})
        model.period_start_date_column = opts[:period_start_column]
        model.period_end_date_column = opts[:period_end_column]
      end

      module ClassMethods
        attr_accessor :period_start_date_column, :period_end_date_column

        # Inheriting classes have the same start/end date columns
        def inherited(subclass)
          super

          ds = dataset

          subclass.period_start_date_column = period_start_date_column
          subclass.period_end_date_column = period_end_date_column
          subclass.instance_eval do
            set_dataset(ds)
          end
        end

        def period_start_date_column
          @period_start_date_column.presence || "#{table_name}__validity_start_date".to_sym
        end

        def period_end_date_column
          @period_end_date_column.presence || "#{table_name}__validity_end_date".to_sym
        end

        def point_in_time
          Thread.current[::TimeMachine::THREAD_DATETIME_KEY]
        end

        def strategy
          Thread.current[::TimeMachine::THREAD_STRATEGY_KEY] || :relevant
        end
      end

      module InstanceMethods
        def point_in_time
          self.class.point_in_time
        end

        def actual(assoc)
          klass = assoc.to_s.classify.constantize

          case self.class.strategy
          when :absolute
            klass.filter{|o| o.<=(klass.period_start_date_column, klass.point_in_time) & (o.>=(klass.period_end_date_column, klass.point_in_time) | ({klass.period_end_date_column => nil})) }
          else # relevant
            klass.filter{|o| o.<=(klass.period_start_date_column, validity_start_date) & (o.>=(klass.period_end_date_column, validity_end_date) | ({klass.period_end_date_column => nil})) }
          end
        end
        private :actual
      end

      module DatasetMethods
        def actual
          filter{|o| o.<=(model.period_start_date_column, model.point_in_time) & (o.>=(model.period_end_date_column, model.point_in_time) | ({model.period_end_date_column => nil})) }
        end

        def with_actual(assoc)
          klass = assoc.to_s.classify.constantize

          if klass.point_in_time.present?
            filter{|o| o.<=(klass.period_start_date_column, klass.point_in_time) & (o.>=(klass.period_end_date_column, klass.point_in_time) | ({klass.period_end_date_column => nil})) }
          else
            self
          end
        end
      end
    end
  end
end
