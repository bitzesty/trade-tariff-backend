require 'rails_helper'

describe Api::V2::Sections::SearchReferencesController do
  it_behaves_like 'v2 search references controller' do
    let(:search_reference_parent)  { create :section }
    let(:search_reference)         { create :search_reference, referenced: search_reference_parent }
    let(:collection_query)         {
      { section_id: search_reference_parent.id }
    }
    let(:resource_query)           {
      collection_query.merge(id: search_reference.id)
    }
  end
end
