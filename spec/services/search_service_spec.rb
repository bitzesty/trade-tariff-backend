require 'spec_helper'

describe SearchService do
  describe 'initialization' do
    let(:query) { Forgery(:basic).text }

    it 'assigns search query' do
      SearchService.new(q: query).q.should == query
    end

    it 'raises an error if search query is blank' do
      expect{ SearchService.new(q: nil) }.to raise_error SearchService::EmptyQuery
    end
  end

  # Searching in local tables
  describe 'exact search' do
    context 'chapters' do
      let(:chapter) { create :chapter }
      let(:pattern) {
        {
          type: 'exact_match',
          entries: [
            {
              endpoint: 'chapters',
              id: chapter.goods_nomenclature_item_id.first(2)
            }
          ]
        }
      }

      it 'returns endpoint and identifier if provided with 2 symbol chapter code' do
        result = SearchService.new(q: chapter.goods_nomenclature_item_id.first(2)).perform.to_json

        result.should match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 3 symbol chapter code' do
        result = SearchService.new(q: chapter.goods_nomenclature_item_id.first(2)).perform.to_json

        result.should match_json_expression pattern
      end
    end

    context 'headings' do
      let(:heading) { create :heading }
      let(:pattern) {
        {
          type: 'exact_match',
          entries: [
            {
              endpoint: 'headings',
              id: heading.goods_nomenclature_item_id.first(4)
            }
          ]
        }
      }

      it 'returns endpoint and identifier if provided with 4 symbol heading code' do
        result = SearchService.new(q: heading.goods_nomenclature_item_id.first(4)).perform.to_json

        result.should match_json_expression pattern
      end

      it 'returns endpoint and identifier if provided with matching 6 (or any between length of 4 to 9) symbol heading code' do
        result = SearchService.new(q: heading.goods_nomenclature_item_id.first(6)).perform.to_json

        result.should match_json_expression pattern
      end
    end

    context 'commodities' do
      let(:commodity) { create :commodity, :declarable }
      let(:heading) { create :heading, :declarable }
      let(:commodity_pattern) {
        {
          type: 'exact_match',
          entries: [
            {
              endpoint: 'commodities',
              id: commodity.goods_nomenclature_item_id.first(10)
            }
          ]
        }
      }
      let(:heading_pattern) {
        {
          type: 'exact_match',
          entries: [
            {
              endpoint: 'headings',
              id: heading.goods_nomenclature_item_id.first(4)
            }
          ]
        }
      }

      it 'returns endpoint and identifier if provided with 10 symbol commodity code' do
        result = SearchService.new(q: commodity.goods_nomenclature_item_id.first(10)).perform.to_json

        result.should match_json_expression commodity_pattern
      end

      it 'returns endpoint and identifier if provided with matching 12 symbol commodity code' do
        result = SearchService.new(q: commodity.goods_nomenclature_item_id + commodity.producline_suffix).perform.to_json

        result.should match_json_expression commodity_pattern
      end

      it 'returns endpoint and identifier if provided with matching 10 symbol declarable heading code' do
        result = SearchService.new(q: heading.goods_nomenclature_item_id).perform.to_json

        result.should match_json_expression heading_pattern
      end
    end
  end

  # Searching in ElasticSearch index
  describe 'fuzzy search' do
  end
end
