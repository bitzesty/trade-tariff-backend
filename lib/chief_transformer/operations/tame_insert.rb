require_relative 'tame_operation'

class ChiefTransformer
  class Processor
    class TameInsert < TameOperation
      def process
        update_or_create_tame_components_for(record)
        create_new_measures_for(record)
      end
    end
  end
end
