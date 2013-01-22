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
      end

      module DatasetMethods
        # Use for fetching record inside TimeMachine block.
        #
        # Example:
        #
        #   TimeMachine.now { Commodity.actual.first }
        #
        # Will fetch first commodity that is valid at this point in time.
        # Invoking outside time machine block will probably yield no as
        # current time variable will be nil.
        #
        def actual
          filter{|o| o.<=(model.period_start_date_column, model.point_in_time) & (o.>=(model.period_end_date_column, model.point_in_time) | ({model.period_end_date_column => nil})) }
        end

        # Use for extending datasets and associations, so that specified
        # klass would respect current time in TimeMachine.
        #
        # Example
        #
        #   TimeMachine.now { Footnote.actual
        #                             .with_actual(FootnoteDescriptionPeriod)
        #                             .joins(:footnote_description_periods)
        #                             .first }
        #
        # Useful for forming time bound associations.
        #
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
