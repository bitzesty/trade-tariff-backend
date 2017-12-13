class ChiefTransformer
  class CandidateMeasure < Sequel::Model(:measures_oplog)
    class Collection
      include Enumerable

      attr_reader :measures

      delegate :size, to: :measures

      def initialize(measures)
        @measures = measures
      end

      def uniq
        # Remove duplicates
        @measures = @measures.uniq{ |m|
          [
            m.measure_type_id,
            m.geographical_area_id,
            m.goods_nomenclature_item_id,
            m.additional_code_type_id,
            m.additional_code_id,
            m.validity_start_date,
            m.validity_end_date
          ].join
        }
      end

      def sort
        @measures = @measures.sort_by{|m|
          m.validity_end_date.to_s
        }.reverse
      end

      def validate
        # This measure does not 'cover' any time frame and wastes space instead
        @measures = @measures.reject{ |m| m.validity_start_date == m.validity_end_date }

        # remove obviously invalid measures
        @measures = @measures.reject{ |m| m.validity_end_date.present? &&
                                          m.validity_start_date > m.validity_end_date }
      end

      def persist
        Sequel::Model.db.transaction do
          @measures.each do |candidate_measure|
            if candidate_measure.valid?
              candidate_measure.save
              if candidate_measure.operation == :create
                ChiefTransformer::MeasuresLogger.add_created(candidate_measure)
              end
            else
              ChiefTransformer::MeasuresLogger.add_failed(candidate_measure)
            end
          end
        end
      end
    end
  end
end
