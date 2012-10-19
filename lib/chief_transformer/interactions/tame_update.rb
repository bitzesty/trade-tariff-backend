require_relative 'tame_interaction'

class ChiefTransformer
  class Processor
    class TameUpdate < TameInteraction
      def process
        if record.le_tsmp.present?
          # Find all Measures that fall into record validity date range
          # and set their end dates to le_tsmp.
          Measure.with_measure_type(record.measure_type)
                 .with_tariff_measure_number(record.tar_msr_no)
                 .valid_since(record.fe_tsmp)
                 .valid_to(record.le_tsmp)
                 .each do |measure|
            MeasureLogger.log(measure, :update, {validity_end_date: record.fe_tsmp}, record, record.origin) if logging_enabled?
            measure.update validity_end_date: record.le_tsmp
          end
        else
          end_measures_for(record)
          update_or_create_tame_components_for(record)
          create_new_measures_for(record)
        end
      end
    end
  end
end
