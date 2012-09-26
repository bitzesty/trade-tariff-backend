class ChiefTransformer
  class MeasureBuilder
    module PaginatedMfcmBuilder
      extend self

      def build(*args)
        raise TransformException.new("#{self.class}.build expects block as argument") unless block_given?

        options = args.extract_options!

        Chief::Mfcm.each_page(options[:per_page]) do |batch|
          yield(batch.map { |mfcm|
            build_from(mfcm)
           }.flatten.compact)
        end
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
