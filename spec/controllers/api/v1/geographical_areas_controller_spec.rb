require 'spec_helper'

describe Api::V1::GeographicalAreasController, "GET #countries" do
  render_views

  let!(:geographical_area1) { create :geographical_area, :with_description, :country }
  let!(:geographical_area2) { create :geographical_area, :with_description, :country }

  let(:pattern) {
    [
      {geographical_area_id: String, description: String},
      {geographical_area_id: String, description: String}
    ]
  }

  it 'returns rendered records' do
    get :countries, format: :json

    response.body.should match_json_expression pattern
  end
end
