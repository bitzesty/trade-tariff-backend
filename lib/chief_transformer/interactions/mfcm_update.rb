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
                   MeasureLogger.log(measure, :update, {validity_end_date: record.le_tsmp}, record, record.origin)
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
              if record.tame.present?
                if record.tame.has_tamfs?
                  record.tame.tamfs.map { |tamf|
                    CandidateMeasure.new(mfcm: record,
                                         tame: record.tame,
                                         tamf: tamf,
                                         operation: :insert)
                  }
                else
                  [CandidateMeasure.new(mfcm: record,
                                        tame: record.tame,
                                        operation: :insert)]
                end
              end
            ].flatten.compact)
            candidate_measures.log(record)
            candidate_measures.persist
          end
        end
      end
    end
  end
end
