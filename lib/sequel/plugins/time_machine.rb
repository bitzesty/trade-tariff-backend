require "date"

module Sequel
  module Plugins
    module TimeMachine
      THREAD_NOW_KEY = :sequel_plugins_time_machine_now

      module ClassMethods
        def at(date = Date.today)
          Thread.current[THREAD_NOW_KEY] = date

          self
        end

        def now
          Thread.current[THREAD_NOW_KEY] || Date.today
        end

        def current
          where('validity_start_date <= ? AND (effective_end_date >= ? OR effective_end_date IS NULL)', now, now)
        end
      end
    end
  end
end
