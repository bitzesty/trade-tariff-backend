require "date"

module TimeMachine
  THREAD_DATETIME_KEY = :time_machine_now

  # Travel to specified date and time
  def self.at(datetime, &block)
      datetime = DateTime.now if datetime.blank?
      datetime = begin
                   DateTime.parse(datetime.to_s)
                 rescue ArgumentError
                   DateTime.now
                  end

      previous = Thread.current[THREAD_DATETIME_KEY]
      raise ArgumentError, "requires a block" unless block_given?
      Thread.current[THREAD_DATETIME_KEY] = datetime
      yield
    ensure
      Thread.current[THREAD_DATETIME_KEY] = previous
  end

  def self.now(&block)
    at(DateTime.now, &block)
  end
end
