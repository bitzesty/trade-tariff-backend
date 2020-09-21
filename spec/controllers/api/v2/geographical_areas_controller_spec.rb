require 'rails_helper'

describe Api::V2::GeographicalAreasController, "GET #countries" do
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
    {
      data: [
        { id: String, type: String, attributes: { id: String, description: String, geographical_area_id: String }, relationships: { children_geographical_areas: { data: [] } } },
        { id: String, type: String, attributes: { id: String, description: String, geographical_area_id: String }, relationships: { children_geographical_areas: { data: [] } } },
        { id: String, type: String, attributes: { id: String, description: String, geographical_area_id: String }, relationships: { children_geographical_areas: { data: [] } } }
      ]
    }
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
             validity_start_date: "2014-12-31 00:00:00",
             validity_end_date: "2015-12-31 00:00:00"
    }
    let!(:geographical_area2) {
      create :geographical_area,
             :with_description,
             :country,
             validity_start_date: "2014-12-01 00:00:00",
             validity_end_date: "2015-12-01 00:00:00"
    }
    let!(:geographical_area3) {
      create :geographical_area,
             :with_description,
             geographical_code: "2",
             validity_start_date: "2014-12-31 00:00:00",
             validity_end_date: "2015-12-31 00:00:00"
    }

    let(:pattern) {
      {
        data: [
          { id: String, type: String, attributes: { id: String, description: String, geographical_area_id: String }, relationships: { children_geographical_areas: { data: [] } } },
          { id: String, type: String, attributes: { id: String, description: String, geographical_area_id: String }, relationships: { children_geographical_areas: { data: [] } } }
        ]
      }
    }

    before do
      get :countries,
          params: { as_of: "2015-12-04" },
          format: :json
    end

    it "finds one area" do
      expect(response.body).to match_json_expression pattern
    end

    it "includes area 1" do
      expect(response.body.to_s).to include(
        "\"id\":\"#{geographical_area1.geographical_area_id}\""
      )
    end

    it "doesn't include area 2" do
      expect(response.body.to_s).to_not include(
        "\"id\":\"#{geographical_area2.geographical_area_id}\""
      )
    end
  end

  describe 'with children geographical areas' do
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
    let!(:parent_geographical_area) {
      create :geographical_area,
        :with_description,
        geographical_code: "1"
    }
    let!(:geographical_area_membership1) {
      create :geographical_area_membership,
        geographical_area_sid: geographical_area1.geographical_area_sid,
        geographical_area_group_sid: parent_geographical_area.geographical_area_sid
    }
    let!(:geographical_area_membership3) {
      create :geographical_area_membership,
        geographical_area_sid: geographical_area3.geographical_area_sid,
        geographical_area_group_sid: parent_geographical_area.geographical_area_sid
    }

    let(:pattern) {
      { data: [
        { 
          id: String,
          type: "geographical_area",
          attributes: { 
            id: String,
            description: String,
            geographical_area_id: String
          }, 
          relationships: { 
            children_geographical_areas: { 
              data: [] 
            } 
          } 
        }, 
        { 
          id: String,
          type: "geographical_area",
          attributes: {
            id: String,
            description: String,
            geographical_area_id: String
          }, 
          relationships: { 
            children_geographical_areas: { 
              data: [] 
            } 
          } 
        }, 
        { 
          id: String,
          type: "geographical_area",
          attributes: {
            id: String,
            description: String,
            geographical_area_id: String
          }, 
          relationships: { 
            children_geographical_areas: { 
              data: [] 
            } 
          } 
        }, 
        { 
          id: parent_geographical_area.geographical_area_id,
          type: "geographical_area",
          attributes: {
            id: parent_geographical_area.geographical_area_id,
            description: String,
            geographical_area_id: String
          }, 
          relationships: { 
            children_geographical_areas: { 
              data: [
                { 
                  id: geographical_area1.geographical_area_id,
                  type: "geographical_area"
                }, 
                { 
                  id: geographical_area3.geographical_area_id,
                  type: "geographical_area"
                }
              ] 
            } 
          } 
        } ] 
      }
    }

    it 'returns rendered records' do
      get :index, format: :json

      expect(response.body).to match_json_expression pattern
    end
  end
end
