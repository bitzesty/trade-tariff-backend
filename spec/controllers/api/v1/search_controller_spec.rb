require 'spec_helper'

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

    before {
      post :search, { q: chapter.to_param, as_of: chapter.validity_start_date }
    }

    it { should respond_with(:success) }
    it 'returns exact match endpoint and indetifier if query for exact record' do
        response.body.should match_json_expression pattern
    end
  end

  describe 'fuzzy matching', vcr: { cassette_name: "search#search_fuzzy", match_requests_on: [:uri], erb: true } do
    let(:chapter) { create :chapter, :with_description, description: "horse", validity_start_date: Date.today }
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

    before {
      post :search, { q: chapter.description,  as_of: chapter.validity_start_date }
    }

    it { should respond_with(:success) }
    it 'returns records grouped by type' do
        response.body.should match_json_expression pattern
    end
  end

  describe 'errors' do
    let(:pattern) {
      {
        q: Array,
        as_of: Array
      }
    }

    before {
      post :search
    }

    it { should respond_with(:success) }
    it 'returns list of errors' do
        response.body.should match_json_expression pattern
    end
  end
end
