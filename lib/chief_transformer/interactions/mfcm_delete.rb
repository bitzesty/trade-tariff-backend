require 'chief_transformer/interactions/interaction'

class ChiefTransformer
  class Processor
    class MfcmDelete < Interaction
      def process
        Measure.with_measure_type(record.measure_type)
               .with_gono_id(record.cmdty_code)
               .valid_to(record.fe_tsmp).each do |measure|
            MeasureLogger.log(measure, :delete, {validity_end_date: record.fe_tsmp}, record, record.origin) if logging_enabled?
            measure.update validity_end_date: record.fe_tsmp
        end
      end
    end
  end
end
