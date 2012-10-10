require 'chief_transformer/interactions/interaction'

class ChiefTransformer
  class Processor
    class TameInteraction < Interaction
      TAME_DUTY_EXPRESSION_ID = "01"

      private

      # Update all earlier measures and set their validity end date to fe_tsmp
      def end_measures_for(tame)
        Measure.national
               .with_measure_type(tame.measure_type)
               .valid_before(tame.fe_tsmp)
               .with_tariff_measure_number(tame.tar_msr_no)
               .not_terminated
               .each do |measure|
          MeasureLogger.log(measure, :update, {validity_end_date: tame.fe_tsmp}, tame, tame.origin)
          measure.update validity_end_date: tame.fe_tsmp
        end
      end

      def create_new_measures_for(tame)
        # Create new measures for MFCMs with later start date
        candidate_measures = CandidateMeasure::Collection.new(tame.mfcms_dataset.valid_to(record.fe_tsmp).map do |mfcm|
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
        end.flatten)
        candidate_measures.log(tame)
        candidate_measures.persist
      end

      def update_or_create_tame_components_for(tame)
        Measure.with_measure_type(tame.measure_type)
               .valid_from(tame.fe_tsmp)
               .with_tariff_measure_number(tame.tar_msr_no)
               .eager(:measure_components)
               .all
               .each do |measure|
                 if tame.has_tamfs?
                   tame.tamfs.each do |tamf|
                     measure.measure_components_dataset.destroy
                     tamf.measure_components.each do |mc|
                       mc.measure_sid = measure.measure_sid
                       mc.save
                     end
                   end
                 else
                  if tame_component = measure.measure_components
                                             .detect{|c| c.duty_expression_id == TAME_DUTY_EXPRESSION_ID }
                    tame_component.update duty_amount: tame.adval_rate
                  else
                    # TODO implement component creation if needed
                  end
                end
        end
      end
    end
  end
end
