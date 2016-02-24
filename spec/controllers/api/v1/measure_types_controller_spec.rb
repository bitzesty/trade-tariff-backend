require 'rails_helper'

describe Api::V1::MeasureTypesController do
  render_views

  before { login_as_api_user }

  describe "GET to #index" do
    let!(:national_measure_type) { create :measure_type, :national }
    let!(:non_national_measure_type) { create :measure_type, :non_national }


    let(:response_pattern) {
      [
        {
          id: String,
          validity_start_date: String,
          description: String
        }.ignore_extra_keys!
      ]
    }

    it 'returns national measure types' do
      get :index, format: :json
      expect(response.body).to match_json_expression response_pattern
      expect(parsed_body.map { |f| f["id"] }).to include national_measure_type.pk
    end

    it 'does not return non-national measure type' do
      get :index, format: :json

      expect(parsed_body.map { |f| f["id"] }).not_to include non_national_measure_type.pk
    end
  end

  describe "GET to #show" do
    let!(:national_measure_type) { create :measure_type, :national }
    let!(:non_national_measure_type) { create :measure_type, :non_national }

    let(:response_pattern) {
      {
        id: String,
        validity_start_date: String,
        description: String
      }.ignore_extra_keys!
    }

    it 'returns national measure types' do
      get :show, id: national_measure_type.pk, format: :json

      expect(response.body).to match_json_expression response_pattern
    end

    it 'does not return non-national measure types' do
      get :show, id: non_national_measure_type.pk, format: :json

      expect(response.status).to eq 404
    end
  end

  describe "PUT to #update" do
    it 'updates national measure type' do
      national_measure_type = create :measure_type, :national
      put :update, id: national_measure_type.pk, measure_type: { description: 'new description' }, format: :json
      expect(parsed_body["description"]).to eq('new description')
    end

    it 'does not update non-national measure type' do
      non_national_measure_type = create :measure_type, :non_national
      put :update, id: non_national_measure_type.pk, measure_type: {}, format: :json
      expect(response.status).to eq 404
    end
  end


  def parsed_body
    JSON.parse(response.body)
  end
end