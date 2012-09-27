class ChiefTransformer
  class MeasureBuilder
    module TamfBuilder
      def self.build(*args)
        options = args.extract_options!
        query_arguments = options.fetch(:query_arguments, '')

        Chief::Tamf.reverse.where(query_arguments).map do |tamf|
          tamf.mfcms.map {|mfcm|
            CandidateMeasure.new(mfcm: mfcm,
                                 tame: tamf.tame,
                                 tamf: tamf,
                                 amend_indicator: tamf.amend_indicator,
                                 origin: :tamf)
          }
        end
      end
    end
  end
end
