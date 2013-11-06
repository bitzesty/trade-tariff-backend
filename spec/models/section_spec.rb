require 'spec_helper'

describe Section do
  it_behaves_like 'Tire indexable model'

  describe 'associations' do
    describe 'chapters' do
      it 'does not include HiddenGoodsNomenclatures' do
        pending
      end
    end
  end
end
