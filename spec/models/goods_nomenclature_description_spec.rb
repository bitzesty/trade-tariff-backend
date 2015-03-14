require 'rails_helper'

describe GoodsNomenclatureDescription do
  describe '#to_s' do
    let(:gono_description) { build :goods_nomenclature_description }

    it 'is an alias for description' do
      expect(gono_description.to_s).to eq gono_description.description
    end
  end
end
