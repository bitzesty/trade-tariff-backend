class ChiefTransformer
  class MeasureLogger
    attr_reader :measure, :operation, :changes, :origin, :initiator

    def self.log(measure, operation, changes, initiator, origin)
      new(measure, operation, changes, initiator, origin).log
    end

    def initialize(measure, operation, changes, initiator, origin)
      @measure = measure
      @operation = operation
      @changes = changes
      @initiator = initiator
      @origin = origin
    end

    def log
      ChiefTransformer.logger.info "-----------\n#{Time.now} Measure #{operation} for #{measure.inspect}.\n Changes: #{changes}.\n Origin: #{origin}.\n Initiator: #{initiator.inspect}."
    end
  end
end
