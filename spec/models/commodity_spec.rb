require 'spec_helper'

describe Commodity do
  it 'has primary key set to goods_nomenclature_sid' do
    subject.primary_key.should == :goods_nomenclature_sid
  end

  describe 'associations' do
    describe 'measures' do
      let(:measure_type) { create :measure_type, measure_type_id: MeasureType::EXCLUDED_TYPES.sample }
      let(:commodity) { create :commodity, :with_indent }
      let(:measure)   { create :measure, :with_base_regulation,
                                         measure_type_id: measure_type.measure_type_id,
                                         goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      it 'does not include measures for excluded measure types' do
        measure_type
        measure

        commodity.measures.map(&:measure_sid).should_not include measure.measure_sid
      end
    end
  end

  describe '.to_param' do
    let(:commodity) { create :commodity }

    it 'uses goods_nomenclature_item_id as param' do
      commodity.to_param.should == commodity.goods_nomenclature_item_id
    end
  end

  describe '.actual' do
    let!(:actual_commodity)  { create :commodity, :actual }
    let!(:expired_commodity) { create :commodity, :expired }

    context 'when not in TimeMachine block' do
      it 'fetches commodities that are actual Today' do
        commodities = Commodity.actual.all
        commodities.should include actual_commodity
        commodities.should_not include expired_commodity
      end
    end

    context 'when in TimeMachine block' do
      it 'fetches commodities that are actual on specified Date' do
        TimeMachine.at(Date.today.ago(2.years)) do
          commodities = Commodity.actual.all
          commodities.should include actual_commodity
          commodities.should include expired_commodity
        end
      end
    end
  end
end
