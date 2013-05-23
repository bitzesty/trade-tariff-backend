require 'chief_transformer/operations/operation'
require 'chief_transformer/operations/mfcm_operation'

class ChiefTransformer
  class Processor
    class MfcmInsert < MfcmOperation
      def process
        create_measures_for(record)
      end
    end
  end
end
