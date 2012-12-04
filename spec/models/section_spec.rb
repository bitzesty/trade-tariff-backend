require 'spec_helper'

describe Section do
  describe 'associations' do
    describe 'chapters' do
      it 'does not include HiddenGoodsNomenclatures' do
        pending
      end
    end
  end

  describe '.to_param' do
    let(:section) { create :section }

    it 'uses position as param' do
      section.to_param.should == section.position
    end
  end
end
