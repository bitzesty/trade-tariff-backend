require 'rails_helper'

describe Api::V1::SearchController, "POST #search" do
  describe 'exact matching' do
    let(:chapter) { create :chapter }
    let(:pattern) {
      {
        type: 'exact_match',
        entry: {
          endpoint: 'chapters',
          id: chapter.to_param
        }
      }
    }

    it 'returns exact match endpoint and indetifier if query for exact record' do
      post :search, params: { q: chapter.to_param, as_of: chapter.validity_start_date }
      expect(response.status).to eq(200)
      expect(response.body).to match_json_expression pattern
    end
  end

  describe 'fuzzy matching' do
    let(:chapter) { create :chapter, :with_description, description: 'horse', validity_start_date: Date.today }
    let(:pattern) {
      {
        type: 'fuzzy_match',
        reference_match: {
          commodities: Array,
          headings: Array,
          chapters: Array,
          sections: Array
        },
        goods_nomenclature_match: {
          commodities: Array,
          headings: Array,
          chapters: Array,
          sections: Array
        }
      }
    }

    it 'returns records grouped by type' do
      post :search, params: { q: chapter.description,  as_of: chapter.validity_start_date }
      expect(response.status).to eq(200)
      expect(response.body).to match_json_expression pattern
    end
  end

  describe 'errors' do
    let(:pattern) {
      {
        q: Array,
        as_of: Array
      }
    }

    it 'returns list of errors' do
      post :search
      expect(response.status).to eq(200)
      expect(response.body).to match_json_expression pattern
    end
  end
end

describe Api::V1::SearchController, "GET #suggestions" do
  render_views

  let!(:commodity1) { create :commodity }
  let!(:commodity2) { create :commodity }
  let!(:commodity3) { create :commodity }

  let(:pattern) {
    [ { value: String }, { value: String }, { value: String } ]
  }

  it 'returns rendered suggestions' do
    get :suggestions, format: :json

    expect(response.body).to match_json_expression pattern
  end

  it 'includes commodity 2' do
    get :suggestions, format: :json

    expect(response.body.to_s).to include(commodity2.goods_nomenclature_item_id)
  end

  describe "machine timed" do
    let!(:commodity1) { create :commodity, validity_end_date: "2015-12-31", validity_start_date: "2000-12-31" }
    let!(:commodity2) { create :commodity, validity_end_date: "2015-12-01", validity_start_date: "2000-12-31" }
    let!(:commodity3) { create :commodity, validity_end_date: "2015-12-31", validity_start_date: "2000-12-31" }

    let(:pattern) {
      [ { value: String }, { value: String } ]
    }

    before do
      get :suggestions, params: { as_of: "2015-12-04 00:00:00" }, format: :json
    end

    it "returns rendered records" do
      expect(response.body).to match_json_expression pattern
    end

    it "includes commodity 1" do
      expect(response.body.to_s).to include(commodity1.goods_nomenclature_item_id)
    end

    it "doesn't include commodity 2" do
      expect(response.body.to_s).to_not include(commodity2.goods_nomenclature_item_id)
    end
  end

  describe 'with search_references' do
    let(:heading) { create :heading }
    let!(:search_reference_heading) {
      create :search_reference, heading: heading, heading_id: heading.to_param, title: 'test heading 1'
    }

    it "includes search_reference_heading" do
      get :suggestions, format: :json

      expect(response.body.to_s).to include(search_reference_heading.title)
    end
  end
end
