require 'chief_transformer/interactions/interaction'

class ChiefTransformer
  class Processor
    class MfcmUpdate < Interaction
      def process
        if record.le_tsmp.present?
          Measure.with_measure_type(record.measure_type)
                 .with_gono_id(record.cmdty_code)
                 .valid_to(record.le_tsmp)
                 .each do |measure|
                   MeasureLogger.log(measure, :update, {validity_end_date: record.le_tsmp}, record, record.origin) if logging_enabled?
                   measure.update validity_end_date: record.le_tsmp
                 end
        else
          if Measure.with_measure_type(record.measure_type)
                    .with_gono_id(record.cmdty_code)
                    .valid_to(record.fe_tsmp)
                    .terminated
                    .any?
            # Create new measures for MFCMs with later start date
            candidate_measures = CandidateMeasure::Collection.new([
              record.tames.map { |tame|
                if tame.has_tamfs?
                   tame.tamfs.map { |tamf|
                    CandidateMeasure.new(mfcm: record,
                                         tame: tame,
                                         tamf: tamf,
                                         operation: :insert)
                  }
                else
                  [CandidateMeasure.new(mfcm: record,
                                        tame: tame,
                                        operation: :insert)]
                end
              }
            ].flatten.compact)
            candidate_measures.log(record) if logging_enabled?
            candidate_measures.persist
          end
        end
      end
    end
  end
end
