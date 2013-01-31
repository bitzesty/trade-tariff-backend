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
        # Remove duplicates
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

      def validate
        # This measure does not 'cover' any time frame and wastes space instead
        @measures = @measures.reject{|m| m.validity_start_date == m.validity_end_date }

        # remove obviously invalid measures
        @measures = @measures.reject { |m| m.validity_end_date.present? &&
                                           m.validity_start_date > m.validity_end_date }
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
