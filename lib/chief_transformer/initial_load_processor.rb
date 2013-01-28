class ChiefTransformer
  class InitialLoadProcessor
    attr_reader :dataset, :per_page

    def initialize(dataset, per_page)
      @dataset = dataset
      @per_page = per_page
    end

    def process
      dataset.each_page(per_page) do |batch|
        candidate_measures = CandidateMeasure::Collection.new(
          batch.map { |mfcm|
            mfcm.tames.map{|tame|
              if tame.tamfs.any?
                tame.tamfs.map{|tamf|
                  CandidateMeasure.new(mfcm: mfcm, tame: tame, tamf: tamf)
                }
              else
                [CandidateMeasure.new(mfcm: mfcm, tame: tame)]
              end
            }
          }.flatten.compact)
        candidate_measures.sort
        candidate_measures.uniq
        candidate_measures.validate
        candidate_measures.persist
      end

      cleanup
    end

    private

    def cleanup
      [Chief::Mfcm, Chief::Tame, Chief::Tamf].each{|model|
        model.unprocessed.update(processed: true)
      }
    end
  end
end
