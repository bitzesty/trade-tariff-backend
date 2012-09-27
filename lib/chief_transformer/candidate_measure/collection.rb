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
        @measures.uniq! { |m| [m.measure_type, m.geographical_area, m.goods_nomenclature_item_id, m.validity_start_date, m.validity_end_date, m.additional_code, m.additional_code_type] }
      end

      def validate
      end

      def persist
        CandidateMeasure.unrestrict_primary_key

        Sequel::Model.db.transaction do
          @measures.each do |candidate_measure|
            case candidate_measure.amend_indicator
            when "I"
              measures_for_update = Measure.eager(:measure_components,
                                                  :footnote_association_measures,
                                                  :measure_conditions).for_candidate_measure(candidate_measure).all

              if measures_for_update.any?
                measures_for_update.each do |existing_measure|
                  candidate_measure.measure_sid = existing_measure.measure_sid
                  candidate_measure.candidate_associations.each do |association, records|
                    existing_measure.associations[association].each do |record|
                      record.delete
                    end
                  end

                  candidate_measure.candidate_associations.persist

                  existing_measure.update candidate_measure.values.diff(existing_measure.values).except(Measure.primary_key)
                end
              else
                candidate_measure.save if candidate_measure.valid?
              end
            when "U"
              measures_for_update = Measure.eager(:measure_components,
                                                  :footnote_association_measures,
                                                  :measure_conditions).for_candidate_measure(candidate_measure).all

              if measures_for_update.any?
                measures_for_update.each do |existing_measure|
                  candidate_measure.measure_sid = existing_measure.measure_sid
                  candidate_measure.candidate_associations.each do |association, records|
                    existing_measure.associations[association].each do |record|
                      record.delete
                    end
                  end

                  candidate_measure.candidate_associations.persist

                  existing_measure.update candidate_measure.values.diff(existing_measure.values).except(Measure.primary_key)
                end
              else
                Measure.expired_before(candidate_measure).each do |expired_measure|
                  expired_measure.update validity_end_date: candidate_measure.validity_start_date
                end

                candidate_measure.save if candidate_measure.valid?
              end
            when "X"
              existing_measures = Measure.expired_before(candidate_measure)

              if existing_measures.any?
                existing_measures.each do |existing_measure|
                  existing_measure.update validity_end_date: candidate_measure.validity_start_date
                end
              else
                Measure.for_candidate_measure(candidate_measure).each do |existing_measure|
                  existing_measure.update validity_end_date: candidate_measure.validity_start_date
                end
              end
            end
          end
        end
      end
    end
  end
end
