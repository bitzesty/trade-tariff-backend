require 'rails_helper'

describe Cache::HeadingSerializer do
  describe '#as_json' do
    let(:heading) { create :heading, :non_grouping,
                           :non_declarable,
                           :with_description }
    let!(:chapter) { create :chapter,
                            :with_section, :with_description,
                            goods_nomenclature_item_id: heading.chapter_id
    }
    let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
    let!(:commodity) { heading.commodities.first }
    let(:measure_type) { create :measure_type, measure_type_id: '103' }
    let!(:measure) {
      create :measure,
             measure_type_id: measure_type.measure_type_id,
             goods_nomenclature: commodity,
             goods_nomenclature_sid: commodity.goods_nomenclature_sid
    }
    let(:serializer) { described_class.new(heading.reload) }
  
    let(:pattern) {
      {
        goods_nomenclature_sid: Integer,
        goods_nomenclature_item_id: String,
        producline_suffix: String,
        validity_start_date: String,
        validity_end_date: nil,
        description: String,
        formatted_description: String,
        bti_url: String,
        number_indents: Integer,
        chapter: {
          goods_nomenclature_sid: Integer,
          goods_nomenclature_item_id: String,
          producline_suffix: String,
          validity_start_date: String,
          validity_end_date: nil,
          description: String,
          formatted_description: String,
          chapter_note: nil,
          guide_ids: Array,
          guides: Array
        },
        section_id: Integer,
        section: {
          id: Integer,
          numeral: String,
          title: String,
          position: Integer,
          section_note: nil
        },
        footnotes: [
          {
            footnote_id: String,
            validity_start_date: String,
            validity_end_date: nil,
            code: String,
            description: String,
            formatted_description: String
          }
        ],
        commodities: [
          {
            goods_nomenclature_sid: Integer,
            goods_nomenclature_item_id: String,
            validity_start_date: String,
            validity_end_date: nil,
            goods_nomenclature_indents: [
              {
                goods_nomenclature_indent_sid: Integer,
                validity_start_date: String,
                validity_end_date: nil,
                number_indents: Integer,
                productline_suffix: nil
              }
            ],
            goods_nomenclature_descriptions: [
              {
                goods_nomenclature_description_period_sid: Integer,
                validity_start_date: String,
                validity_end_date: nil,
                description: String,
                formatted_description: String,
                description_plain: String
              }
            ],
            overview_measures: [
              {
                measure_sid: Integer,
                effective_start_date: String,
                effective_end_date: String,
                goods_nomenclature_sid: Integer,
                vat: false,
                duty_expression_id: String,
                duty_expression: {
                  id: String,
                  base: String,
                  formatted_base: String
                },
                measure_type_id: String,
                measure_type: {
                  measure_type_id: String,
                  description: String
                }
              }
            ]
          }
        ]
      }
    }
    
    it 'returns json representation for ElasticSearch' do
      expect(serializer.as_json).to match_json_expression pattern
    end
  end
end