class ChiefTransformer
  class MeasureLogger
    attr_reader :measure, :operation, :changes, :origin

    def self.log(measure, operation, changes, origin)
      new(measure, operation, changes, origin).log
    end

    def initialize(measure, operation, changes, origin)
      @measure = measure
      @operation = operation
      @changes = changes
      @origin = origin
    end

    def log
      ChiefTransformer.logger.info "#{Time.now} Measure #{operation} for #{measure.inspect}.\n Changes: #{changes}.\n Origin: #{origin.inspect}."
    end
  end
end
