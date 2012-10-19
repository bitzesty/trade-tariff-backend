class ChiefTransformer
  class Processor
    class Interaction
      attr_reader :record, :logging_enabled

      def initialize(record, logging_enabled = true)
        @record = record
        @logging_enabled = logging_enabled
      end

      alias :logging_enabled? :logging_enabled
    end
  end
end
