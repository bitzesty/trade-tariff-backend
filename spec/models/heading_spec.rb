require 'spec_helper'

describe Heading do
  describe '.to_param' do
    let(:heading) { create :heading }

    it 'uses first four digits of goods_nomenclature_item_id as param' do
      heading.to_param.should == heading.goods_nomenclature_item_id.first(4)
    end
  end
end
