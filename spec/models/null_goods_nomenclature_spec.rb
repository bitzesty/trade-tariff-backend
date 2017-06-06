require 'rails_helper'

describe NullGoodsNomenclature do
  let(:subject) { described_class.new }

  describe '#description' do
    it 'should return empty string' do
      expect(subject.description).to eq('')
    end
  end
end
