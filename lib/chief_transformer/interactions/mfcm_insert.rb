require 'chief_transformer/interactions/interaction'

class ChiefTransformer
  class Processor
    class MfcmInsert < Interaction
      def process
        candidate_measures = CandidateMeasure::Collection.new(
          [record].flatten.map{ |mfcm|
              mfcm.tames.map { |tame|
              if tame.has_tamfs?
                tame.tamfs.map { |tamf|
                  CandidateMeasure.new(mfcm: mfcm,
                                       tame: tame,
                                       tamf: tamf,
                                       operation: :insert)
                }
              else
                [CandidateMeasure.new(mfcm: mfcm,
                                      tame: tame,
                                      operation: :insert)]
              end
            }
          }.flatten.compact)
        candidate_measures.sort
        candidate_measures.uniq
        candidate_measures.log(record) if logging_enabled?
        candidate_measures.persist
      end
    end
  end
end
