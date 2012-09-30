require_relative 'tame_interaction'

class ChiefTransformer
  class Processor
    class TameDelete < TameInteraction
      def process
        end_measures_for(record)
      end
    end
  end
end
