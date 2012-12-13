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
        @measures = @measures.uniq {|m|
          [m.measure_type, m.geographical_area, m.goods_nomenclature_item_id,
           m.additional_code_type, m.additional_code, m.validity_start_date,
           m.validity_end_date].join
        }
      end

      def sort
        @measures = @measures.sort_by {|m|
          m.validity_end_date.to_s
        }.reverse
      end

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
