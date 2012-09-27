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
        cms = []
        cms << if mfcm.tame.present?
          mfcm.tame.tamfs.map { |tamf|
            CandidateMeasure.new(mfcm: mfcm,
                                 tame: mfcm.tame,
                                 tamf: tamf,
                                 amend_indicator: mfcm.amend_indicator,
                                 origin: :mfcm)
          }.tap! { |candidate_measures|
            # When TAME has no subsidiary TAMFs and no candidate measures are built
            # from the combo. Create Measure just from TAME record.
            candidate_measures << CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, amend_indicator: mfcm.amend_indicator) if candidate_measures.empty?
          }
        end
        if mfcm.tamfs.any?
          cms << mfcm.tamfs.map { |tamf|
            CandidateMeasure.new(mfcm: mfcm,
                                 tamf: tamf,
                                 tame: tamf.tame,
                                 amend_indicator: mfcm.amend_indicator,
                                 origin: :mfcm)
          }
        end
        cms
      end
    end
  end
end
