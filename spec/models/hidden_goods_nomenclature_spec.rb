require 'spec_helper'

describe HiddenGoodsNomenclature do
  it { should validate_presence.of(:goods_code_identifier) }

  describe '.to_pattern' do
    let!(:hidden_gono1) { create :hidden_goods_nomenclature, goods_code_identifier: "99" }
    let!(:hidden_gono2) { create :hidden_goods_nomenclature, goods_code_identifier: "0101" }

    it 'returns regexp pattern of all goods code identifiers' do
      HiddenGoodsNomenclature.to_pattern.should eq /^(0101|99)/
    end
  end
end
