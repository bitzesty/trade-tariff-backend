require 'rails_helper'

describe Api::V2::FootnotesController, type: :controller do
  render_views

  context 'footnotes search' do

    let!(:footnote) { create :footnote }
    let!(:footnote_description) { create :footnote_description, :with_period, footnote_type_id: footnote.footnote_type_id, footnote_id: footnote.footnote_id }
    let!(:measure) { create :measure }
    let!(:footnote_association_measure) { create :footnote_association_measure, footnote_type_id: footnote.footnote_type_id, footnote_id: footnote.footnote_id, measure_sid: measure.measure_sid }
    let!(:goods_nomenclature) { measure.goods_nomenclature }
    let!(:footnote_association_goods_nomenclature) { create :footnote_association_goods_nomenclature, footnote_type: footnote.footnote_type_id, footnote_id: footnote.footnote_id, goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid }

    let(:pattern) {
      {
        data: [{
          id: String,
          type: "footnote",
          attributes: {
            code: String,
            footnote_type_id: String,
            footnote_id: String,
            description: String,
            formatted_description: String
          },
          relationships: {
            measures: {
              data: [
                {
                  id: String,
                  type: "measure"
                }
              ].ignore_extra_values!
            },
            goods_nomenclatures: {
              data: [
                {
                  id: String,
                  type: "goods_nomenclature"
                }
              ].ignore_extra_values!
            }
          }
        }].ignore_extra_values!,
        included: [{
          id: String,
          type: "measure",
          attributes: {
            id: Integer,
            validity_start_date: String,
            validity_end_date: String
          },
          relationships: {
            goods_nomenclature: {
              data: {
                id: String,
                type: "goods_nomenclature"
              }
            }
          }
        },
        {
          id: String,
          type: "goods_nomenclature",
          attributes: {
            goods_nomenclature_item_id: String,
            goods_nomenclature_sid: Integer,
            description: String,
            number_indents: Integer,
            productline_suffix: String
          }
        }].ignore_extra_values!
      }
    }

    let(:pattern_empty) {
      {
        data: [],
        included: []
      }
    }

    it 'returns footnotes, related measures, and goods nomenclatures when searching by code' do
      get :search, params: { code: footnote.code }, format: :json

      expect(response.body).to match_json_expression pattern
    end

    it 'returns footnotes, related measures, and goods nomenclatures when searching by part of a code' do
      get :search, params: { code: footnote.footnote_type_id }, format: :json

      expect(response.body).to match_json_expression pattern
    end

    it 'returns footnotes, related measures, and goods nomenclatures when searching by footnote type' do
      get :search, params: { type: footnote.footnote_type_id }, format: :json

      expect(response.body).to match_json_expression pattern
    end

    it 'returns footnotes, related measures, and goods nomenclatures when searching by description' do
      get :search, params: { description: footnote.description }, format: :json

      expect(response.body).to match_json_expression pattern
    end

    it 'returns 404 if no valid parameter is provided' do
      get :search, format: :json

      expect(response.status).to eq(404)
    end

    it 'returns an empty JSON object if no footnotes are found' do
      get :search, params: {code: 'F-O-O-B-A-R'}, format: :json

      expect(response.body).to match_json_expression pattern_empty
    end
  end
end 
