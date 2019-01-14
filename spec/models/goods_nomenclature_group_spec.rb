require 'rails_helper'

describe GoodsNomenclatureGroup do
  describe 'validations' do
    describe 'NG1' do
      it { is_expected.to validate_uniqueness.of(%i[goods_nomenclature_group_id goods_nomenclature_group_type]) }
    end

    describe 'NG2' do
      it { is_expected.to validate_validity_dates }
    end
  end
end
