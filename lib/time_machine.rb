require "date"

module TimeMachine
  THREAD_DATE_KEY = :time_machine_now

  # Temporary for easier console access
  def self.at(date = Date.today, &block)
      date = Date.today if date.blank?
      date = Date.parse(date) if date.is_a?(String)

      previous = Thread.current[THREAD_DATE_KEY]
      raise ArgumentError, "requires a block" unless block_given?
      Thread.current[THREAD_DATE_KEY] = date
      yield
    ensure
      Thread.current[THREAD_DATE_KEY] = previous
  end

  def self.now(&block)
    at(Date.today, &block)
  end
end
