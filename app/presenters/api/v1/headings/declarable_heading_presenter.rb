module Api
  module V1
    module Headings
      class DeclarableHeadingPresenter

        attr_reader :heading, :import_measures, :export_measures

        delegate :goods_nomenclature_sid, :goods_nomenclature_item_id, :description, :bti_url,
                 :formatted_description, :basic_duty_rate, :meursing_code,
                 :footnote_ids, :section_id, :chapter_id, :chapter, :section, :footnotes,
                 to: :heading


        def initialize(heading, measures)
          @heading = heading
          @import_measures = measures.select(&:import)
          @export_measures = measures.select(&:export)
        end

        def import_measure_ids
          import_measures.pluck(:measure_sid)
        end

        def export_measure_ids
          export_measures.pluck(:measure_sid)
        end
      end
    end
  end
end