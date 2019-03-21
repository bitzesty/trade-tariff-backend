module Api
  module V1
    module Headings
      class DeclarableHeadingSerializer
        include FastJsonapi::ObjectSerializer
        cache_options enabled: true, cache_length: 12.hours
        set_id :goods_nomenclature_sid
        set_type :heading
        attributes :goods_nomenclature_item_id, :description, :bti_url,
                   :formatted_description, :basic_duty_rate, :meursing_code
        attribute :declarable do
          true
        end

        has_many :footnotes, serializer: Api::V1::Headings::FootnoteSerializer
        has_one :section, serializer: Api::V1::Headings::SectionSerializer
        has_one :chapter, serializer: Api::V1::Headings::ChapterSerializer
        has_many :import_measures, record_type: :measure, serializer: Api::V1::Measures::MeasureSerializer
        has_many :export_measures, record_type: :measure, serializer: Api::V1::Measures::MeasureSerializer
      end
    end
  end
end
