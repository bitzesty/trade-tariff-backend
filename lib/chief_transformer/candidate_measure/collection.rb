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

      def sort
        @measures = @measures.sort_by(&:tame_fe_tsmp).reverse
      end

      def log(initiator)
        @measures.each do |measure|
          MeasureLogger.log(measure, :insert, {}, initiator, initiator.origin)
        end
      end

      def persist
        @measures.each do |candidate_measure|
          candidate_measure.save if candidate_measure.valid?
        end
      end
    end
  end
end
