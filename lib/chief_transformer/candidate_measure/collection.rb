class ChiefTransformer
  class CandidateMeasure < Sequel::Model
    class Collection
      include Enumerable

      attr_reader :measures

      delegate :size, to: :measures

      def initialize(measures)
        @measures = measures
      end

      def uniq
        @measures = @measures.uniq
      end

      def log(origin)
        @measures.each do |measure|
          MeasureLogger.log(measure, :insert, {}, origin)
        end
      end

      # Only processes initial import records
      def persist
        Sequel::Model.db.transaction do
          @measures.each do |candidate_measure|
            candidate_measure.save if candidate_measure.valid?
          end
        end
      end
    end
  end
end
