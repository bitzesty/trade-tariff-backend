require_relative 'tame_operation'

class ChiefTransformer
  class Processor
    class TameDelete < TameOperation
      def process
        end_measures_for(record)
      end
    end
  end
end
