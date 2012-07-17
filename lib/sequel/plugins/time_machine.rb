require "date"

module Sequel
  module Plugins
    module TimeMachine
      module ClassMethods
        def at(date = Date.today)
          Thread.current[::TimeMachine::THREAD_DATE_KEY] = date

          self
        end

        def point_in_time
          Thread.current[::TimeMachine::THREAD_DATE_KEY] || Date.today
        end

        def actual
          where('validity_start_date <= ? AND (validity_end_date >= ? OR validity_end_date IS NULL)', point_in_time, point_in_time)
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
