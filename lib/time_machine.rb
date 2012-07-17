require "date"

module TimeMachine
  extend ActiveSupport::Concern

  THREAD_DATE_KEY = :time_machine_now

  module ClassMethods
    def self.at(date = Date.today, &block)
      previous = Thread.current[THREAD_DATE_KEY]
        raise ArgumentError, "requires a block" unless block_given?
        Thread.current[THREAD_DATE_KEY] = date
        yield
      ensure
        Thread.current[THREAD_DATE_KEY] = previous
    end
  end

  # Temporary for easier console access
  def self.at(date = Date.today, &block)
    ClassMethods.at(date, &block)
  end

  def self.now(&block)
    at(Date.today, &block)
  end
end
