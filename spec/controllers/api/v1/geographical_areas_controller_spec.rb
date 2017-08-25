require 'rails_helper'

describe Api::V1::GeographicalAreasController, "GET #countries" do
  render_views

  let!(:geographical_area1) {
    create :geographical_area,
           :with_description,
           :country
  }
  let!(:geographical_area2) {
    create :geographical_area,
           :with_description,
           :country
  }
  let!(:geographical_area3) {
    create :geographical_area,
           :with_description,
           geographical_code: "2"
  }

  let(:pattern) {
    [
      {id: String, description: String},
      {id: String, description: String},
      {id: String, description: String}
    ]
  }

  it 'returns rendered records' do
    get :countries, format: :json

    expect(response.body).to match_json_expression pattern
  end

  it 'includes geographical areas with code 2' do
    get :countries, format: :json

    expect(response.body.to_s).to include(
      geographical_area3.geographical_area_id
    )
  end

  describe "machine timed" do
    let!(:geographical_area1) {
      create :geographical_area,
             :with_description,
             :country,
             validity_end_date: "2015-12-31 00:00:00"
    }
    let!(:geographical_area2) {
      create :geographical_area,
             :with_description,
             :country,
             validity_end_date: "2015-12-01 00:00:00"
    }
    let!(:geographical_area3) {
      create :geographical_area,
             :with_description,
             geographical_code: "2",
             validity_end_date: "2015-12-31 00:00:00"
    }

    let(:pattern) {
      [
        { id: String, description: String },
        { id: String, description: String }
      ]
    }

    before do
      get :countries,
          params: { as_of: "2015-12-04 00:00:00" },
          format: :json
    end

    it "finds one area" do
      expect(response.body).to match_json_expression pattern
    end

    it "includes area 1" do
      expect(response.body.to_s).to include(
        geographical_area1.geographical_area_id
      )
    end

    it "doesn't include area 2" do
      expect(response.body.to_s).to_not include(
        geographical_area2.geographical_area_id
      )
    end
  end
end
