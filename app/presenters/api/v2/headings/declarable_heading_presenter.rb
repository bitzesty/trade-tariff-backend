module Api
  module V2
    module Headings
      class DeclarableHeadingPresenter < SimpleDelegator
        attr_reader :heading, :import_measures, :export_measures

        def initialize(heading, measures)
          super(heading)
          @heading = heading
          @import_measures = measures.select(&:import).map do |measure|
            Api::V2::Measures::MeasurePresenter.new(measure, heading)
          end
          @export_measures = measures.select(&:export).map do |measure|
            Api::V2::Measures::MeasurePresenter.new(measure, heading)
          end
        end

        def import_measure_ids
          import_measures.map(&:measure_sid)
        end

        def export_measure_ids
          export_measures.map(&:measure_sid)
        end

        def footnote_ids
          footnotes.map(&:footnote_id)
        end

        def chapter_id
          heading.chapter.goods_nomenclature_sid
        end
      end
    end
  end
end
