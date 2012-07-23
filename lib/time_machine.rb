require "date"

module TimeMachine
  THREAD_DATETIME_KEY = :time_machine_now
  THREAD_STRATEGY_KEY = :time_machine_strategy

  # Temporary for easier console access
  def self.at(datetime, &block)
      datetime = DateTime.now if datetime.blank?
      datetime = DateTime.parse(datetime) if datetime.is_a?(String)

      previous = Thread.current[THREAD_DATETIME_KEY],
      previous_strategy = Thread.current[THREAD_STRATEGY_KEY]
      raise ArgumentError, "requires a block" unless block_given?
      Thread.current[THREAD_DATETIME_KEY] = datetime
      Thread.current[THREAD_STRATEGY_KEY] = :absolute
      yield
    ensure
      Thread.current[THREAD_DATETIME_KEY] = previous
      Thread.current[THREAD_STRATEGY_KEY] = previous_strategy
  end

  def self.relevant(&block)
      previous_strategy = Thread.current[THREAD_STRATEGY_KEY]
      raise ArgumentError, "requires a block" unless block_given?
      Thread.current[THREAD_STRATEGY_KEY] = :relevant
      yield
    ensure
      Thread.current[THREAD_STRATEGY_KEY] = previous_strategy
  end

  def self.now(&block)
    at(DateTime.now, &block)
  end
end
