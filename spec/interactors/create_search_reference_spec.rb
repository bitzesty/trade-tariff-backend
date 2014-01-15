require 'spec_helper'

describe CreateSearchReference do
  let(:search_client_double) { double('search_client').as_null_object }

  describe '#call' do
    context 'search reference valid' do
      let(:section)                 { create :section }
      let(:search_reference_params) { attributes_for(:search_reference, section_id: section.id) }

      it 'persists search reference to the database' do
        interactor = CreateSearchReference.new(search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(SearchReference.count).to eq 1
      end

      it 'indexes search reference in the search index' do
        interactor = CreateSearchReference.new(search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(search_client_double).to have_received :index
      end
    end

    context 'search reference is not valid' do
      let(:search_reference_params) { attributes_for(:search_reference, section_id: nil) }

      it 'does not persist search reference to the database' do
        CreateSearchReference.create(search_reference_params)

        expect(SearchReference.count).to eq 0
      end

      it 'does not index search referecen in the search index' do
        interactor = CreateSearchReference.new(search_reference_params)
        interactor.search_client = search_client_double

        interactor.call

        expect(search_client_double).not_to have_received :index
      end
    end
  end
end
