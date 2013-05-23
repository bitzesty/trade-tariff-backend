require 'chief_transformer/operations/operation'
require 'chief_transformer/operations/mfcm_operation'

class ChiefTransformer
  class Processor
    class MfcmUpdate < MfcmOperation
      def process
        if record.le_tsmp.present?
          Measure.with_measure_type(record.measure_type)
                 .with_gono_id(record.cmdty_code)
                 .valid_to(record.le_tsmp)
                 .each do |measure|
                   update_record(measure, validity_end_date: record.le_tsmp)
                 end
        else
          if Measure.with_measure_type(record.measure_type)
                    .with_gono_id(record.cmdty_code)
                    .valid_to(record.fe_tsmp)
                    .terminated
                    .any?
            # Create new measures for MFCMs with later start date
            create_measures_for(record)
          end
        end
      end
    end
  end
end
