class ChiefTransformer
  class MeasureBuilder
    module MfcmBuilder
      extend self

      def build(*args)
        options = args.extract_options!
        query_arguments = options.fetch(:query_arguments, '')

        Chief::Mfcm.where(query_arguments).map do |mfcm|
          cms = []
          cms << if mfcm.tame.present?
            mfcm.tame.tamfs.map { |tamf|
              CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, tamf: tamf, amend_indicator: mfcm.amend_indicator)
            }.tap! { |candidate_measures|
              # When TAME has no subsidiary TAMFs and no candidate measures are built
              # from the combo. Create Measure just from TAME record.
              candidate_measures << CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, amend_indicator: mfcm.amend_indicator) if candidate_measures.empty?
            }
          end
          if mfcm.tamfs.any?
            cms << mfcm.tamfs.map { |tamf|
              CandidateMeasure.new(mfcm: mfcm, tamf: tamf, amend_indicator: mfcm.amend_indicator)
            }
          end
          cms
        end.flatten.compact
      end
    end
  end
end
