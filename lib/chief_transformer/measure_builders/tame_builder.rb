class ChiefTransformer
  class MeasureBuilder
    module TameBuilder
      def self.build(*args)
        options = args.extract_options!
        query_arguments = options.fetch(:query_arguments, '')

        Chief::Tame.where(query_arguments).map do |tame|
          tame.mfcms.map {|mfcm|
            CandidateMeasure.new(mfcm: mfcm, tame: tame, amend_indicator: tame.amend_indicator)
          }
          # binding.pry
          # if mfcm.tame.present?
          #   mfcm.tame.tamfs.map { |tamf|
          #   }.tap! { |candidate_measures|
          #     # When TAME has no subsidiary TAMFs and no candidate measures are built
          #     # from the combo. Create Measure just from TAME record.
          #     candidate_measures << CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, amend_indicator: mfcm.amend_indicator) if candidate_measures.empty?
          #   }
          # end
        end
      end
    end
  end
end
