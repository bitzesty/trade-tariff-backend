require 'spec_helper'

describe Chapter do
  describe '.to_param' do
    let(:chapter) { create :chapter }

    it 'uses first two digits of goods_nomenclature_item_id as param' do
      chapter.to_param.should == chapter.goods_nomenclature_item_id.first(2)
    end
  end
end
