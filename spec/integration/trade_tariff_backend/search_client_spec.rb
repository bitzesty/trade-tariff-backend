require 'rails_helper'

describe TradeTariffBackend::SearchClient do
  describe '#search' do
    let(:commodity) {
      create :commodity, :with_description, description: 'test description'
    }

    let(:search_result) {
      TradeTariffBackend.search_client.search q: 'test', index: TradeTariffBackend.search_index_for('search', commodity).name
    }

    it 'searches in supplied index' do
      expect(search_result.hits.total).to be >= 1
      expect(search_result.hits.hits.map { |hit|
        hit._source.goods_nomenclature_item_id
      }).to include commodity.goods_nomenclature_item_id
    end

    it 'returns results wrapped in Hashie::Mash structure' do
      expect(search_result).to be_kind_of Hashie::Mash
    end
  end
end
