require "date"

module TimeMachine
  THREAD_DATETIME_KEY = :time_machine_now

  # Temporary for easier console access
  def self.at(datetime, &block)
      datetime = DateTime.now if datetime.blank?
      datetime = DateTime.parse(datetime) if datetime.is_a?(String)

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
