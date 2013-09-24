require 'spec_helper'

describe DestroySearchReference do
  let(:search_index_double) { double('search_index').as_null_object }

  describe '#call' do
    let(:search_reference) { create(:search_reference) }

    it 'removes search reference to the database' do
      DestroySearchReference.destroy(search_reference)

      expect(SearchReference.count).to eq 0
    end

    it 'removes search reference from the search index' do
      interactor = DestroySearchReference.new(search_reference)
      interactor.search_index = search_index_double

      interactor.call

      expect(search_index_double).to have_received :for
    end
  end
end
