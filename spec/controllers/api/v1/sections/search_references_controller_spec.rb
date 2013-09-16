require 'spec_helper'

describe Api::V1::Sections::SearchReferencesController do
  it_behaves_like 'search references controller' do
    let(:search_reference_parent)  { create :section }
    let(:search_reference)         { create :search_reference, section_id: search_reference_parent.id }
    let(:collection_query)         {
      { section_id: search_reference_parent.id }
    }
    let(:resource_query)           {
      collection_query.merge(id: search_reference.id)
    }
  end
end
