class ChiefTransformer
  class CandidateMeasure < Sequel::Model
    class CandidateAssociations
      attr_reader :map, :measure

      delegate :[], :has_key?, :each, to: :map

      def initialize(measure)
        @measure = measure
        @map = {}
      end

      def push(association_name, record)
        @map[association_name] ||= []
        @map[association_name] += [record].flatten
      end

      def set(association_name, record)
        @map[association_name] = record
      end

      def map=(new_map)
        @map = new_map
      end

      def persist
        assign_measure_sid

        Sequel::Model.db.transaction do
          @map.each do |association, records|
            [records].flatten.each(&:save)
          end
        end
      end

      private

      def assign_measure_sid
        @map.each do |association, records|
          if records.is_a?(Array)
            records.each do |record|
              record.measure_sid = measure.measure_sid if record.respond_to?(:measure_sid=)
            end
          else
            records.measure_sid = measure.measure_sid if records.respond_to?(:measure_sid=)
          end
        end
      end
    end
  end
end
