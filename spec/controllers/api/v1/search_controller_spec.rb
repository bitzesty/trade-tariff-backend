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

    before {
      post :search, { t: chapter.to_param, as_of: chapter.validity_start_date }
    }

    it { is_expected.to respond_with(:success) }
    it 'returns exact match endpoint and indetifier if query for exact record' do
      expect(response.body).to match_json_expression pattern
    end
  end

  describe 'fuzzy matching' do
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
      post :search, { t: chapter.description,  as_of: chapter.validity_start_date }
    }

    it { is_expected.to respond_with(:success) }
    it 'returns records grouped by type' do
      expect(response.body).to match_json_expression pattern
    end
  end

  describe 'errors' do
    let(:pattern) {
      {
        t: Array,
        as_of: Array
      }
    }

    before {
      post :search
    }

    it { is_expected.to respond_with(:success) }
    it 'returns list of errors' do
        expect(response.body).to match_json_expression pattern
    end
  end
end
