require 'chief_transformer/operations/operation'

class ChiefTransformer
  class Processor
    class MfcmUpdate < Operation
      def process
        if record.le_tsmp.present?
          Measure.with_measure_type(record.measure_type)
                 .with_gono_id(record.cmdty_code)
                 .valid_to(record.le_tsmp)
                 .each do |measure|
                   measure.update validity_end_date: record.le_tsmp,
                                  justification_regulation_id: measure.measure_generating_regulation_id,
                                  justification_regulation_role: measure.measure_generating_regulation_role,
                                  operation_date: operation_date
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
                                         operation: :create,
                                         operation_date: record.operation_date)
                  }
                else
                  [CandidateMeasure.new(mfcm: record,
                                        tame: record.tame,
                                        operation: :create,
                                        operation_date: record.operation_date)]
                end
              end
            ].flatten.compact)
            candidate_measures.persist
          end
        end
      end
    end
  end
end
