require 'spec_helper'

describe HiddenGoodsNomenclature do
  it 'validates presence of goods_nomenclature_item_id' do
    hidden_goods_nomenclature = build :hidden_goods_nomenclature, goods_nomenclature_item_id: nil
    hidden_goods_nomenclature.valid?.should be_false
  end

  describe '.codes' do
    let!(:hidden_gono1) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: "9900000000" }
    let!(:hidden_gono2) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: "0101000000" }

    it 'returns array of hidden codes' do
      HiddenGoodsNomenclature.codes.should eq [hidden_gono2.goods_nomenclature_item_id,
                                               hidden_gono1.goods_nomenclature_item_id]
    end
  end
end
