require 'spec_helper'

describe Commodity do
  it 'has primary key set to goods_nomenclature_sid' do
    subject.primary_key.should == :goods_nomenclature_sid
  end

  describe 'associations' do
    describe 'measures' do
      let(:measure_type) { create :measure_type, measure_type_id: MeasureType::EXCLUDED_TYPES.sample }
      let(:commodity)    { create :commodity, :with_indent }
      let(:measure)      { create :measure, :with_base_regulation,
                                             measure_type_id: measure_type.measure_type_id,
                                             goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      it 'does not include measures for excluded measure types' do
        measure_type
        measure

        commodity.measures.map(&:measure_sid).should_not include measure.measure_sid
      end
    end

    describe 'measure duplication' do
      # sometimes measures have the same base regulation id and
      # validity_start date
      # need to group and choose the latest one
      let(:measure_type) { create :measure_type }
      let(:commodity)    { create :commodity, :with_indent }
      let(:measure1)     { create :measure, :with_base_regulation,
                                             measure_sid: 1,
                                             measure_type_id: measure_type.measure_type_id,
                                             goods_nomenclature_sid: commodity.goods_nomenclature_sid  }
      let(:measure2)     { create :measure,  measure_sid: 2,
                                             measure_generating_regulation_id: measure1.measure_generating_regulation_id,
                                             measure_type_id: measure_type.measure_type_id,
                                             goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      it 'groups measures by measure_generating_regulation_id and picks latest one' do
        measure1
        measure2

        commodity.measures.map(&:measure_sid).should     include measure1.measure_sid
        commodity.measures.map(&:measure_sid).should_not include measure2.measure_sid
      end
    end

    describe 'measures for export' do
      let(:export_measure_type) { create :measure_type, :export }
      let(:commodity)           { create :commodity, :with_indent }
      let(:export_measure)      { create :measure, :with_base_regulation,
                                                   measure_type_id: export_measure_type.measure_type_id,
                                                   goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      let(:import_measure_type) { create :measure_type, :import }
      let(:commodity)           { create :commodity, :with_indent }
      let(:import_measure)      { create :measure, :with_base_regulation,
                                                   measure_type_id: import_measure_type.measure_type_id,
                                                   goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      let(:regular_measure_type)         { create :measure_type }
      let(:export_national_measure)      { create :measure, :with_base_regulation,
                                                            export: true,
                                                            national: true,
                                                            measure_type_id: regular_measure_type.measure_type_id,
                                                            goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      it 'fetches measures that have measure type with proper trade movement code' do
        export_measure_type
        export_measure

        import_measure_type
        import_measure

        commodity.export_measures.map(&:measure_sid).should     include export_measure.measure_sid
        commodity.export_measures.map(&:measure_sid).should_not include import_measure.measure_sid
      end

      it 'fetches measures that have export set to true' do
        export_national_measure

        commodity.export_measures.map(&:measure_sid).should include export_national_measure.measure_sid
      end
    end

    describe 'measures and regulations' do
      let!(:commodity)       { create :commodity, :with_indent,
                                                  validity_start_date: Time.now.ago(10.years) }
      let!(:measure_type)    { create :measure_type }
      let!(:base_regulation) { create :base_regulation, effective_end_date: Time.now.ago(1.month) }
      let!(:measure1)        { create :measure, measure_generating_regulation_id: base_regulation.base_regulation_id,
                                                validity_end_date: Time.now.ago(30.months),
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                validity_start_date: Time.now.ago(10.years),
                                                measure_type_id: measure_type.measure_type_id,
                                                geographical_area_sid: 1  }
      let!(:measure2)        { create :measure, measure_generating_regulation_id: base_regulation.base_regulation_id,
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                measure_type_id: measure_type.measure_type_id,
                                                validity_start_date: Time.now.ago(10.years),
                                                validity_end_date: Time.now.ago(18.months),
                                                geographical_area_sid: 2 }
      let!(:measure3)        { create :measure, measure_generating_regulation_id: base_regulation.base_regulation_id,
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                measure_type_id: measure_type.measure_type_id,
                                                validity_start_date: Time.now.ago(10.years),
                                                validity_end_date: nil,
                                                geographical_area_sid: 3 }

      it 'measure validity date superseeds regulation validity date' do
        measures = TimeMachine.at(Time.now.ago(1.year)) { Commodity.actual.first.measures }.map(&:measure_sid)
        measures.should     include measure3.measure_sid
        measures.should_not include measure2.measure_sid
        measures.should_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(2.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        measures.should     include measure3.measure_sid
        measures.should     include measure2.measure_sid
        measures.should_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(3.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        measures.should     include measure3.measure_sid
        measures.should     include measure2.measure_sid
        measures.should     include measure1.measure_sid
      end
    end
  end

  describe '#to_param' do
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
