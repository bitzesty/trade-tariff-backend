require 'spec_helper'

describe DestroySearchReference do
  let(:search_client_double) { double('search_client').as_null_object }

  describe '#call' do
    let(:search_reference) { create(:search_reference) }

    it 'removes search reference to the database' do
      interactor = DestroySearchReference.new(search_reference)
      interactor.search_client = search_client_double

      interactor.call

      expect(SearchReference.count).to eq 0
    end

    it 'removes search reference from the search index' do
      interactor = DestroySearchReference.new(search_reference)
      interactor.search_client = search_client_double

      interactor.call

      expect(search_client_double).to have_received :delete
    end
  end
end
