require 'spec_helper'

describe GoodsNomenclatureGroup do
  describe 'validations' do
    describe 'NG1' do
      it { should validate_uniqueness.of([:goods_nomenclature_group_id, :goods_nomenclature_group_type]) }
    end

    describe 'NG2' do
      it { should validate_validity_dates }
    end
  end
end
