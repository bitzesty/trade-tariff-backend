require 'rails_helper'

describe Api::V1::MeasureTypesController, "GET to #index" do
  render_views

  let!(:national_measure_type) { create :measure_type, :national }
  let!(:non_national_measure_type) { create :measure_type, :non_national }

  before { login_as_api_user }

  let(:response_pattern) {
    [
      {
        id: String,
        validity_start_date: String,
        description: String
      }.ignore_extra_keys!
    ]
  }

  let(:json_body) {
    JSON.parse(response.body)
  }

  specify 'returns national measure types' do
    get :index, format: :json
    expect(response.body).to match_json_expression response_pattern
    expect(json_body.map { |f| f["id"] }).to include national_measure_type.pk
  end

  specify 'does not return non-national measure type' do
    get :index, format: :json

    expect(json_body.map { |f| f["id"] }).not_to include non_national_measure_type.pk
  end
end

describe Api::V1::MeasureTypesController, "GET to #show" do
  render_views

  let!(:national_measure_type) { create :measure_type, :national }
  let!(:non_national_measure_type) { create :measure_type, :non_national }

  before { login_as_api_user }

  let(:response_pattern) {
    {
      id: String,
      validity_start_date: String,
      description: String
    }.ignore_extra_keys!
  }

  specify 'returns national measure types' do
    get :show, id: national_measure_type.pk, format: :json

    expect(response.body).to match_json_expression response_pattern
  end

  specify 'does not return non-national measure types' do
    get :show, id: non_national_measure_type.pk, format: :json

    expect(response.status).to eq 404
  end
end

describe Api::V1::MeasureTypesController, "PUT to #update" do
  render_views

  before { login_as_api_user }

  let!(:national_measure_type) { create :measure_type, :national }
  let!(:non_national_measure_type) { create :measure_type, :non_national }

  specify 'updates national measure type' do
    expect {
      put :update, id: national_measure_type.pk, measure_type: { description: 'new description' }, format: :json
    }.to change { national_measure_type.reload.description }.to('new description')
  end

  specify 'does not update non-national measure type' do
    put :update, id: non_national_measure_type.pk, measure_type: {}, format: :json

    expect(response.status).to eq 404
  end
end
