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

      # Removes processed mfcms, tames and tamfs
      # I think we should just mark them as processed
      def clean
        @measures.all.each do |measure|
        # Find all MFCMs that have identical msrgp_code, msr_type, tty_code, fe_date and set transformed = 1
        # measure.mfcm.update transformed: true
        # measure.tame.update transformed: true
        # measure.tamf.update transformed: true if measure.tamf.present?
        end
      end
    end
  end
end
