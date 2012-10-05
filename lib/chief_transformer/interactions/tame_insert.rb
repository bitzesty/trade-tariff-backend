require_relative 'tame_interaction'

class ChiefTransformer
  class Processor
    class TameInsert < TameInteraction
      def process
        update_or_create_tame_components_for(record)
        create_new_measures_for(record)
      end
    end
  end
end
