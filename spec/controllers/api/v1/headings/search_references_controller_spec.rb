require 'rails_helper'

describe Api::V1::Headings::SearchReferencesController do
  it_behaves_like 'search references controller' do
    let(:search_reference_parent)  { create :heading }
    let(:search_reference)         { create :search_reference, heading_id: search_reference_parent.short_code }
    let(:collection_query)         {
      { heading_id: search_reference_parent.goods_nomenclature_item_id.first(4) }
    }
    let(:resource_query)           {
      collection_query.merge(id: search_reference.id)
    }
  end
end
