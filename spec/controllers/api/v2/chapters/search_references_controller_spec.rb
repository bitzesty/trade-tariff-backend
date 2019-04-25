require 'rails_helper'

describe Api::V2::Chapters::SearchReferencesController do
  it_behaves_like 'v2 search references controller' do
    let(:search_reference_parent)  { create :chapter }
    let(:search_reference)         { create :search_reference, chapter_id: search_reference_parent.short_code }
    let(:collection_query)         {
      { chapter_id: search_reference_parent.goods_nomenclature_item_id.first(2) }
    }
    let(:resource_query)           {
      collection_query.merge(id: search_reference.id)
    }
  end
end
