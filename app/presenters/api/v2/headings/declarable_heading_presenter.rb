module Api
  module V1
    module Headings
      class DeclarableHeadingPresenter < SimpleDelegator

        attr_reader :heading, :import_measures, :export_measures, :cache_key

        def initialize(heading, measures, cache_key)
          super(heading)
          @heading = heading
          @import_measures = measures.select(&:import).map do |measure|
            Api::V1::Measures::MeasurePresenter.new(measure, heading)
          end
          @export_measures = measures.select(&:export).map do |measure|
            Api::V1::Measures::MeasurePresenter.new(measure, heading)
          end
          @cache_key = cache_key
        end

        def import_measure_ids
          import_measures.map(&:measure_sid)
        end

        def export_measure_ids
          export_measures.map(&:measure_sid)
        end
      end
    end
  end
end