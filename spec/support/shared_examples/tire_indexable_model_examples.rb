require 'spec_helper'

shared_examples_for 'Tire indexable model' do
  describe '.paginate' do
    it 'can be paginated' do
      expect(described_class).to respond_to(:paginate)
    end

    it 'delegates pagination to dataset' do
      allow(described_class).to receive(:paginate).and_call_original

      described_class.paginate(page: 1, per_page: 50)
    end
  end
end
