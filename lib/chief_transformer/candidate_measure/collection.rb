class ChiefTransformer
  class CandidateMeasure < Sequel::Model
    class Collection
      include Enumerable

      attr_reader :measures

      delegate :size, to: :measures

      def initialize(measures)
        @measures = measures
      end

      def merge
      end

      def validate
      end

      def persist
        Sequel::Model.db.transaction do
          @measures.each do |candidate_measure|
            case candidate_measure.amend_indicator
            when "I"
              candidate_measure.save if candidate_measure.valid?
            when "U"
              measures_for_update = Measure.for_candidate_measure(candidate_measure)
              if measures_for_update.any?
                measures_for_update.each do |existing_measure|
                  existing_measure.update candidate_measure.values.diff(existing_measure.values.except(Measure.primary_key))
                end
              else
                # MFCM Scenario 3
                candidate_measure.save
              end
            when "X"
              Measure.for_candidate_measure(candidate_measure).each do |existing_measure|
                existing_measure.destroy
              end
            end
          end
        end
      end
    end
  end
end
