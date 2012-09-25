class ChiefTransformer
  class MeasureBuilder
    module MfcmBuilder
      extend self

      def batch_build(per_page)
        raise TransformException.new("MeasureBuilder::MfcmBuilder.batch_build expects block as argument") unless block_given?

        Chief::Mfcm.each_page(per_page) do |batch|
          yield(batch.map { |mfcm|
            build_from(mfcm)
           }.flatten.compact)
        end
      end

      def build
      end

      private

      def build_from(mfcm)
        if mfcm.tame.present?
          mfcm.tame.tamfs.map { |tamf|
            CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, tamf: tamf)
          }.tap! { |candidate_measures|
            # When TAME has no subsidiary TAMFs and no candidate measures are built
            # from the combo. Create Measure just from TAME record.
            candidate_measures << CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame) if candidate_measures.empty?
          }
        end
      end
    end
  end
end
