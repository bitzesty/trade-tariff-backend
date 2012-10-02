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
        mfcm.tames.map{|tame|
          if tame.tamfs.any?
            tame.tamfs.map{|tamf|
              CandidateMeasure.new(mfcm: mfcm, tame: tame, tamf: tamf)
            }
          else
            [CandidateMeasure.new(mfcm: mfcm, tame: tame)]
          end
        }.flatten
      end
    end
  end
end
