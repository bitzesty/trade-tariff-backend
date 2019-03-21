require 'rails_helper'

describe Api::V1::Commodities::SearchReferencesController do
  it_behaves_like 'search references controller' do
    let(:search_reference_parent)  { create :commodity, :declarable }
    let(:search_reference)         { create :search_reference, commodity_id: search_reference_parent.code }
    let(:collection_query)         {
      { commodity_id: search_reference_parent.goods_nomenclature_item_id }
    }
    let(:resource_query)           {
      collection_query.merge(id: search_reference.id)
    }
  end
end
