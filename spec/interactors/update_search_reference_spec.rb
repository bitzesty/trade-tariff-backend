require 'spec_helper'

describe UpdateSearchReference do
  let(:search_client_double) { double('search_client').as_null_object }

  describe '#call' do
    let!(:search_reference)        { create :search_reference }

    context 'search reference valid' do
      let(:section)                 { create :section }
      let(:search_reference_params) { attributes_for(:search_reference, title: 'new_title', section_id: section.id) }

      it 'updates search reference record in the database' do
        interactor = UpdateSearchReference.new(search_reference, search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(SearchReference.count).to eq 1
        expect(SearchReference.first.title).to eq 'new_title'
      end

      it 'indexes search reference in the search index' do
        interactor = UpdateSearchReference.new(search_reference, search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(search_client_double).to have_received :index
      end
    end

    context 'search reference is not valid' do
      let(:search_reference_params) { attributes_for(:search_reference, title: nil, section_id: nil) }

      it 'does not update search reference record in the database' do
        UpdateSearchReference.update(search_reference, search_reference_params)

        expect(SearchReference.count).to eq 1
        expect(SearchReference.first.title).not_to eq 'new_title'
      end

      it 'does not index search reference in the search index' do
        interactor = UpdateSearchReference.new(search_reference, search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(search_client_double).not_to have_received :index
      end
    end
  end
end
