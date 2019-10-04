require 'rails_helper'

describe Api::V2::CertificatesController, type: :controller do
  render_views

  context 'certificates search' do

    let!(:certificate) { create :certificate }
    let!(:certificate_description) {
      create :certificate_description,
        :with_period,
        certificate_type_code: certificate.certificate_type_code,
        certificate_code: certificate.certificate_code
    }
    let!(:measure) { create :measure }
    let!(:goods_nomenclature) { measure.goods_nomenclature }
    let!(:measure_condition) {
      create :measure_condition,
        certificate_type_code: certificate.certificate_type_code,
        certificate_code: certificate.certificate_code,
        measure_sid: measure.measure_sid
    }
    let!(:goods_nomenclature_description) { create :goods_nomenclature_description, goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid }

    let(:pattern) {
      {
        data: [{
          id: String,
          type: "certificates",
          attributes: {
            certificate_type_code: String,
            certificate_code: String,
            description: String,
            formatted_description: String
          },
          relationships: {
            measures: {
              data: [{
                id: String,
                type: "measure"
              }]
            }
          }
        }],
        included: [{
          id: String,
          type: "measure",
          attributes: {
            id: Integer,
            validity_start_date: String,
            validity_end_date: String,
            goods_nomenclature_item_id: String
          },
          relationships: {
            goods_nomenclature: {
              data: {
                id: String,
                type: "goods_nomenclature"
              }
            }
          }
        }, {
          id: String,
          type: "goods_nomenclature",
          attributes: {
            goods_nomenclature_item_id: String,
            goods_nomenclature_sid: Integer,
            description: String,
            number_indents: Integer,
            productline_suffix: String
          }
        }]
      }
    }

    it 'returns rendered found additional codes and related measures and goods nomenclatures' do
      get :search, params: { code: certificate.certificate_code }, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end 
