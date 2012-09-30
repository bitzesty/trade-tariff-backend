class ChiefTransformer
  class Processor
    class MfcmUpdate < Interaction
      def process
        if record.le_tsmp.present?
          Measure.with_measure_type(record.measure_type)
                 .with_gono_id(record.cmdty_code)
                 .valid_to(record.le_tsmp)
                 .each do |measure|
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
              CandidateMeasure.new(mfcm: record, tame: record.tame, operation: :insert)
            ])
            candidate_measures.persist
          end
        end
      end
    end
  end
end
