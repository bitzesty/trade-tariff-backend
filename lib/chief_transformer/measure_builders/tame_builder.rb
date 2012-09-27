class ChiefTransformer
  class MeasureBuilder
    module TameBuilder
      def self.build(*args)
        options = args.extract_options!
        query_arguments = options.fetch(:query_arguments, '')

        Chief::Tame.reverse.where(query_arguments).map do |tame|
          tame.mfcms.map {|mfcm|
            CandidateMeasure.new(mfcm: mfcm,
                                 tame: tame,
                                 amend_indicator: tame.amend_indicator,
                                 origin: :tame)
          }
        end
      end
    end
  end
end
