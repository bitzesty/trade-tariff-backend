require 'spec_helper'

describe HiddenGoodsNomenclature do
  it { should validate_presence.of(:goods_nomenclature_item_id) }

  describe '.codes' do
    let!(:hidden_gono1) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: "9900000000" }
    let!(:hidden_gono2) { create :hidden_goods_nomenclature, goods_nomenclature_item_id: "0101000000" }

    it 'returns array of hidden codes' do
      HiddenGoodsNomenclature.codes.should eq [hidden_gono2.goods_nomenclature_item_id,
                                               hidden_gono1.goods_nomenclature_item_id]
    end
  end
end
