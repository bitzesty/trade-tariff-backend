require 'rails_helper'

describe Api::V1::GeographicalAreasController, "GET #countries" do
  render_views

  let!(:geographical_area1) { create :geographical_area, :with_description, :country }
  let!(:geographical_area2) { create :geographical_area, :with_description, :country }

  let(:pattern) {
    [
      {id: String, description: String},
      {id: String, description: String}
    ]
  }

  it 'returns rendered records' do
    get :countries, format: :json

    expect(response.body).to match_json_expression pattern
  end
end
