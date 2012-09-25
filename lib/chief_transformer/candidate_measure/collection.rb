class ChiefTransformer
  class CandidateMeasure < Sequel::Model
    class Collection
      include Enumerable

      attr_reader :measures

      delegate :size, to: :measures

      def initialize(measures)
        @measures = measures
      end

      def persist
        Sequel::Model.db.transaction do
          @measures.each do |measure|
            measure.save if measure.valid?
          end
        end
      end
    end
  end
end
