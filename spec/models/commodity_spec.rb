require 'rails_helper'

describe Commodity do
  it 'has primary key set to goods_nomenclature_sid' do
    expect(subject.primary_key).to eq :goods_nomenclature_sid
  end

  describe 'associations' do
    describe 'heading' do
      let!(:gono1)  { create :commodity, validity_start_date: Date.new(1999,1,1),
                                         validity_end_date: Date.new(2013,1,1) }
      let!(:gono2)  { create :commodity, goods_nomenclature_item_id: gono1.goods_nomenclature_item_id,
                                         validity_start_date: Date.new(2005,1,1),
                                         validity_end_date: Date.new(2013,1,1) }
      let!(:heading1) { create :heading, goods_nomenclature_item_id: "#{gono1.goods_nomenclature_item_id.first(4)}000000",
                                         validity_start_date: Date.new(1991,1,1),
                                         validity_end_date: Date.new(2002,1,1),
                                         producline_suffix: "80" }
      let!(:heading2) { create :heading, goods_nomenclature_item_id: "#{gono1.goods_nomenclature_item_id.first(4)}000000",
                                         validity_start_date: Date.new(2002,1,1),
                                         validity_end_date: Date.new(2014,1,1),
                                         producline_suffix: "80" }

      context 'fetching actual' do
        it 'fetches correct chapter' do
          TimeMachine.at("2000-1-1") {
            expect(gono1.reload.heading.pk).to eq heading1.pk
          }
          TimeMachine.at("2010-1-1") {
            expect(gono1.reload.heading.pk).to eq heading2.pk
          }
        end
      end

      context 'fetching relevant' do
        it 'fetches correct chapter' do
          TimeMachine.with_relevant_validity_periods {
            expect(gono2.reload.heading.pk).to eq heading2.pk
          }
        end
      end

      context 'heading with sub-headings' do
        # Example from real world scenario
        # https://www.pivotaltracker.com/story/show/55703384

        let!(:sub_heading) { create :heading, goods_nomenclature_item_id: '6308000000',
                                              goods_nomenclature_sid: 43837,
                                              producline_suffix: '10',
                                              validity_start_date: Date.new(1972,1,1) }
        let!(:heading) { create :heading, goods_nomenclature_item_id: '6308000000',
                                              goods_nomenclature_sid: 43838,
                                              producline_suffix: '80',
                                              validity_start_date: Date.new(1972,1,1) }
        let!(:commodity) { create :commodity, :with_indent,
                                              :with_description,
                                              indents: 1,
                                              goods_nomenclature_sid: 91335,
                                              goods_nomenclature_item_id: '6308000015',
                                              producline_suffix: '80',
                                              validity_start_date: Date.new(2009,7,1) }

        it 'correctly identifies heading' do
          expect(commodity.heading).to eq heading
        end
      end
    end

    describe 'chapter' do
      let!(:gono1)  { create :heading, validity_start_date: Date.new(1999,1,1),
                                          validity_end_date: Date.new(2013,1,1) }
      let!(:gono2)  { create :heading, goods_nomenclature_item_id: gono1.goods_nomenclature_item_id,
                                          validity_start_date: Date.new(2005,1,1),
                                          validity_end_date: Date.new(2013,1,1) }
      let!(:chapter1) { create :chapter, goods_nomenclature_item_id: "#{gono1.goods_nomenclature_item_id.first(2)}00000000",
                                         validity_start_date: Date.new(1991,1,1),
                                         validity_end_date: Date.new(2002,1,1) }
      let!(:chapter2) { create :chapter, goods_nomenclature_item_id: "#{gono1.goods_nomenclature_item_id.first(2)}00000000",
                                         validity_start_date: Date.new(2002,1,1),
                                         validity_end_date: Date.new(2014,1,1) }

      context 'fetching actual' do
        it 'fetches correct chapter' do
          TimeMachine.at("2000-1-1") {
            expect(gono1.reload.chapter.pk).to eq chapter1.pk
          }
          TimeMachine.at("2010-1-1") {
            expect(gono1.reload.chapter.pk).to eq chapter2.pk
          }
        end
      end

      context 'fetching relevant' do
        it 'fetches correct chapter' do
          TimeMachine.with_relevant_validity_periods {
            expect(gono2.reload.chapter.pk).to eq chapter2.pk
          }
        end
      end
    end

    describe 'measures' do
      let(:measure_type) { create :measure_type, measure_type_id: MeasureType::EXCLUDED_TYPES.sample }
      let(:commodity)    { create :commodity, :with_indent }
      let(:measure)      { create :measure, measure_type_id: measure_type.measure_type_id,
                                            goods_nomenclature_sid: commodity.goods_nomenclature_sid  }

      it 'does not include measures for excluded measure types' do
        measure_type
        measure

        expect(commodity.measures.map(&:measure_sid)).to_not include measure.measure_sid
      end
    end

    describe 'measure duplication' do
      # sometimes measures have the same base regulation id and
      # validity_start date
      # need to group and choose the latest one
      let(:measure_type) { create :measure_type }
      let(:commodity)    { create :commodity, :with_indent, validity_start_date: Date.today.ago(3.years) }
      let!(:measure1)    { create :measure, measure_sid: 1,
                                            measure_type_id: measure_type.measure_type_id,
                                            additional_code_type_id: nil,
                                            goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                            validity_start_date: Date.today.ago(1.year)  }
      let!(:measure2)    { create :measure,  measure_sid: 2,
                                             measure_generating_regulation_id: measure1.measure_generating_regulation_id,
                                             geographical_area_id: measure1.geographical_area_id,
                                             measure_type_id: measure_type.measure_type_id,
                                             geographical_area_sid: measure1.geographical_area_sid,
                                             goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                             additional_code_type_id: measure1.additional_code_type_id,
                                             additional_code_id: measure1.additional_code_id,
                                             validity_start_date: Date.today.ago(2.years)  }

      it 'groups measures by measure_generating_regulation_id and picks latest one' do
        TimeMachine.at(Date.current) do
          expect(commodity.measures.map(&:measure_sid)).to     include measure1.measure_sid
          expect(commodity.measures.map(&:measure_sid)).to_not include measure2.measure_sid
        end
      end
    end

    describe 'measure duplication on same date but different goods_nomenclature_item_id' do
      let(:measure_type) { create :measure_type }
      let(:commodity)    { create :commodity, :with_indent, validity_start_date: Date.today.ago(3.years), goods_nomenclature_item_id: "2202901919" }
      let!(:measure1)    { create :measure, measure_sid: 1,
                                           measure_type_id: measure_type.measure_type_id,
                                           additional_code_type_id: nil,
                                           goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                           goods_nomenclature_item_id: "2202901900",
                                           validity_start_date: Date.today.ago(1.year)  }
      let!(:measure2)    { create :measure,  measure_sid: 2,
                                            measure_generating_regulation_id: measure1.measure_generating_regulation_id,
                                            geographical_area_id: measure1.geographical_area_id,
                                            measure_type_id: measure_type.measure_type_id,
                                            geographical_area_sid: measure1.geographical_area_sid,
                                            goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                            goods_nomenclature_item_id: "2202901919",
                                            additional_code_type_id: measure1.additional_code_type_id,
                                            additional_code_id: measure1.additional_code_id,
                                            validity_start_date: Date.today.ago(1.years)  }

      it 'groups measures by measure_generating_regulation_id and picks the measure with the highest goods_nomenclature_item_id' do
        TimeMachine.at(Date.current) do
          expect(commodity.measures.map(&:measure_sid)).to_not     include measure1.measure_sid
          expect(commodity.measures.map(&:measure_sid)).to include measure2.measure_sid
        end
      end
    end

    describe 'measures for export' do
      context 'trade movement code' do
        let(:export_measure_type) { create :measure_type, :export }
        let(:commodity1)          { create :commodity, :with_indent }
        let(:export_measure)      { create :measure, measure_type_id: export_measure_type.measure_type_id,
                                                     goods_nomenclature_sid: commodity1.goods_nomenclature_sid  }

        let(:import_measure_type) { create :measure_type, :import }
        let(:commodity2)          { create :commodity, :with_indent }
        let(:import_measure)      { create :measure, measure_type_id: import_measure_type.measure_type_id,
                                                     goods_nomenclature_sid: commodity2.goods_nomenclature_sid  }


        it 'fetches measures that have measure type with proper trade movement code' do
          export_measure_type
          export_measure

          import_measure_type
          import_measure

          expect(commodity1.export_measures.map(&:measure_sid)).to     include export_measure.measure_sid
          expect(commodity1.export_measures.map(&:measure_sid)).to_not include import_measure.measure_sid

          expect(commodity2.import_measures.map(&:measure_sid)).to     include import_measure.measure_sid
          expect(commodity2.import_measures.map(&:measure_sid)).to_not include export_measure.measure_sid
        end
      end

      context 'export refund nomenclature' do
        let!(:commodity) { create :commodity, :with_indent }
        let!(:export_refund_nomenclature) { create :export_refund_nomenclature, :with_indent,
                                                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid }
        let!(:export_measure)             { create :measure, export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid,
                                                             goods_nomenclature_item_id: commodity.goods_nomenclature_item_id  }

        it 'includes measures that belongs to related export refund nomenclature' do
          expect(commodity.measures).to_not be_blank
          expect(commodity.measures.map(&:measure_sid)).to include export_measure.measure_sid
        end
      end
    end

    describe 'measures and base_regulations' do
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
        expect(measures).to     include measure3.measure_sid
        expect(measures).to_not include measure2.measure_sid
        expect(measures).to_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(2.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        expect(measures).to     include measure3.measure_sid
        expect(measures).to     include measure2.measure_sid
        expect(measures).to_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(3.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        expect(measures).to     include measure3.measure_sid
        expect(measures).to     include measure2.measure_sid
        expect(measures).to     include measure1.measure_sid
      end
    end

    describe 'measures and modification_regulations' do
      let!(:commodity)       { create :commodity, :with_indent,
                                                  validity_start_date: Time.now.ago(10.years) }
      let!(:measure_type)    { create :measure_type }
      let!(:modification_regulation) { create :modification_regulation, effective_end_date: Time.now.ago(1.month) }
      let!(:measure1)        { create :measure, measure_generating_regulation_id: modification_regulation.modification_regulation_id,
                                                validity_end_date: Time.now.ago(30.months),
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                validity_start_date: Time.now.ago(10.years),
                                                measure_type_id: measure_type.measure_type_id,
                                                geographical_area_sid: 1  }
      let!(:measure2)        { create :measure, measure_generating_regulation_id: modification_regulation.modification_regulation_id,
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                measure_type_id: measure_type.measure_type_id,
                                                validity_start_date: Time.now.ago(10.years),
                                                validity_end_date: Time.now.ago(18.months),
                                                geographical_area_sid: 2 }
      let!(:measure3)        { create :measure, measure_generating_regulation_id: modification_regulation.modification_regulation_id,
                                                goods_nomenclature_sid: commodity.goods_nomenclature_sid,
                                                measure_type_id: measure_type.measure_type_id,
                                                validity_start_date: Time.now.ago(10.years),
                                                validity_end_date: nil,
                                                geographical_area_sid: 3 }

      it 'measure validity date superseeds regulation validity date' do
        measures = TimeMachine.at(Time.now.ago(1.year)) { Commodity.actual.first.measures }.map(&:measure_sid)
        expect(measures).to     include measure3.measure_sid
        expect(measures).to_not include measure2.measure_sid
        expect(measures).to_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(2.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        expect(measures).to     include measure3.measure_sid
        expect(measures).to     include measure2.measure_sid
        expect(measures).to_not include measure1.measure_sid

        measures = TimeMachine.at(Time.now.ago(3.years)) { Commodity.actual.first.measures }.map(&:measure_sid)
        expect(measures).to     include measure3.measure_sid
        expect(measures).to     include measure2.measure_sid
        expect(measures).to     include measure1.measure_sid
      end
    end
  end

  describe '#to_param' do
    let(:commodity) { create :commodity }

    it 'uses goods_nomenclature_item_id as param' do
      expect(commodity.to_param).to eq commodity.goods_nomenclature_item_id
    end
  end

  describe '.actual' do
    let!(:actual_commodity)  { create :commodity, :actual }
    let!(:expired_commodity) { create :commodity, :expired }

    context 'when not in TimeMachine block' do
      it 'fetches all commodities' do
        commodities = Commodity.all
        expect(commodities).to include actual_commodity
        expect(commodities).to include expired_commodity
      end
    end

    context 'when in TimeMachine block' do
      it 'fetches commodities that are actual on specified Date' do
        TimeMachine.at(Date.today.ago(2.years)) do
          commodities = Commodity.actual.all
          expect(commodities).to include actual_commodity
          expect(commodities).to include expired_commodity
        end
      end
    end
  end

  describe '#children' do
    let!(:heading)    { create :heading, goods_nomenclature_item_id: '8418000000',
                                         validity_start_date: Date.new(2011,1,1) }
    let!(:commodity1) { create :commodity, :with_indent,
                                           indents: 3,
                                           goods_nomenclature_item_id: '8418211000',
                                           producline_suffix: '80',
                                           validity_start_date: Date.new(2011,1,1) }
    let!(:commodity2) { create :commodity, :with_indent,
                                           indents: 3,
                                           goods_nomenclature_item_id: '8418215100',
                                           producline_suffix: '10',
                                           validity_start_date: Date.new(2011,1,1) }
    let!(:commodity3) { create :commodity, :with_indent,
                                           indents: 4,
                                           goods_nomenclature_item_id: '8418215100',
                                           producline_suffix: '80',
                                           validity_start_date: Date.new(2011,1,1) }

    around do |example|
      TimeMachine.at(Date.new(2011,2,1)) do
        example.run
      end
    end

    it 'does not returns children if there are no commodities with higher indent levels and item ids' do
      expect(commodity1.children).to be_empty
    end

    it 'returns children commodities with higher ident levels and items ids' do
      expect(commodity2.children.map(&:pk)).to include commodity3.pk
    end
  end

  describe '#ancestors' do
    describe 'comparing indent numbers' do
      let!(:commodity) { create :commodity, :with_indent, :with_description,
                                            indents: 7,
                                            goods_nomenclature_item_id: '2204219711',
                                            producline_suffix: '80',
                                            validity_start_date: Date.new(2010,1,1) }

      let!(:ancestor_commodity) { create :commodity, :with_description,
                                    goods_nomenclature_item_id: '2204218900',
                                    producline_suffix: '80',
                                    validity_start_date: Date.new(1995,1,1) }
      let!(:indent1) { create(:goods_nomenclature_indent,
                                goods_nomenclature_sid: ancestor_commodity.goods_nomenclature_sid,
                                goods_nomenclature_item_id: ancestor_commodity.goods_nomenclature_item_id,
                                number_indents: 7,
                                validity_start_date: Date.new(2010,1,1))  }
      let!(:indent2) { create(:goods_nomenclature_indent,
                                number_indents: 7,
                                goods_nomenclature_sid: ancestor_commodity.goods_nomenclature_sid,
                                goods_nomenclature_item_id: ancestor_commodity.goods_nomenclature_item_id,
                                validity_start_date: Date.new(1995,1,1))  }

      it 'does not pick ancestor_commodity as ancestor (indent number is not lower (same level))' do
        expect(commodity.ancestors).to eq([])
      end
    end

    describe 'nested commodities' do
      let!(:chapter) { create :chapter, goods_nomenclature_item_id: "8500000000",
                              validity_start_date: Date.new(2010,1,1),
                              producline_suffix: "80" }
      let!(:heading) { create :heading, goods_nomenclature_item_id: "8504000000",
                               validity_start_date: Date.new(2010,1,1),
                               producline_suffix: "80" }
      let!(:commodity0) { create :commodity, :with_indent, :with_description,
                                indents: 4,
                                goods_nomenclature_item_id: '8504909990',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity1) { create :commodity, :with_indent, :with_description,
                                indents: 3,
                                goods_nomenclature_item_id: '8504909900',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity2) { create :commodity, :with_indent, :with_description,
                                indents: 2,
                                goods_nomenclature_item_id: '8504909100',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity3) { create :commodity, :with_indent, :with_description,
                                indents: 1,
                                goods_nomenclature_item_id: '8504900000',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity4) { create :commodity, :with_indent, :with_description,
                                indents: 2,
                                goods_nomenclature_item_id: '8504900500',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity5) { create :commodity, :with_indent, :with_description,
                                indents: 3,
                                goods_nomenclature_item_id: '8504901100',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity6) { create :commodity, :with_indent, :with_description,
                                indents: 4,
                                goods_nomenclature_item_id: '8504901100',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity7) { create :commodity, :with_indent, :with_description,
                                indents: 5,
                                goods_nomenclature_item_id: '8504901190',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity8) { create :commodity, :with_indent, :with_description,
                                indents: 3,
                                goods_nomenclature_item_id: '8504900500',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity9) { create :commodity, :with_indent, :with_description,
                                indents: 4,
                                goods_nomenclature_item_id: '8504901800',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity10) { create :commodity, :with_indent, :with_description,
                                indents: 5,
                                goods_nomenclature_item_id: '8504901899',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity11) { create :commodity, :with_indent, :with_description,
                                indents: 3,
                                goods_nomenclature_item_id: '8504909100',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity12) { create :commodity, :with_indent, :with_description,
                                indents: 5,
                                goods_nomenclature_item_id: '8504901110',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }
      let!(:commodity13) { create :commodity, :with_indent, :with_description,
                                indents: 5,
                                goods_nomenclature_item_id: '8504901120',
                                producline_suffix: '80',
                                validity_start_date: Date.new(2010,1,1) }

      around do |example|
        TimeMachine.at(Date.new(2011,2,1)) do
          example.run
        end
      end

      it 'should return valid ancestors' do
        expect(commodity0.ancestors.map(&:goods_nomenclature_item_id)).to eq(['8504900000', '8504909100', '8504909900'])
        expect(commodity7.ancestors.map(&:goods_nomenclature_item_id)).to eq(['8504900000', '8504900500', '8504901100', '8504901100'])
        expect(commodity10.ancestors.map(&:goods_nomenclature_item_id)).to eq(['8504900000', '8504900500', '8504901100', '8504901800'])
      end

      it 'should return ancestors with indent less then current commodity indent' do
        expect(commodity0.ancestors.map(&:number_indents)).to all( be < commodity0.number_indents )
      end
    end
  end

  describe '#changes' do
    let(:commodity) { create :commodity }

    it 'returns Sequel Dataset' do
      expect(commodity.changes).to be_kind_of Sequel::Dataset
    end

    context 'with commodity changes' do
      let!(:commodity) { create :commodity, operation_date: Date.today }

      it 'includes commodity changes' do
        expect(
          commodity.changes.select { |change|
            change.oid == commodity.oid &&
            change.model == GoodsNomenclature
          }
        ).to be_present
      end
    end

    context 'with associated measure changes' do
      let!(:commodity) { create :commodity, operation_date: Date.yesterday }
      let!(:measure)   {
        create :measure,
               goods_nomenclature: commodity,
               goods_nomenclature_item_id: commodity.goods_nomenclature_item_id,
               operation_date: Date.today
      }

      it 'includes measure changes' do
        expect(
          commodity.changes.select { |change|
            change.oid == measure.oid &&
            change.model == Measure
          }
        ).to be_present
      end
    end
  end

  describe '#declarable?' do
    let(:commodity_80) { create(:commodity, producline_suffix: '80') }
    let(:commodity_10) { create(:commodity, producline_suffix: '10') }

    context 'with children' do
      before do
        allow_any_instance_of(Commodity).to receive(:children).and_return([1])
      end

      it "should return true for producline_suffix == '80'" do
        expect(commodity_80.declarable?).to be_falsey
      end

      it "should return false for other producline_suffix" do
        expect(commodity_10.declarable?).to be_falsey
      end
    end

    context 'without children' do
      before do
        allow_any_instance_of(Commodity).to receive(:children).and_return([])
      end

      it "should return true for producline_suffix == '80'" do
        expect(commodity_80.declarable?).to be_truthy
      end

      it "should return false for other producline_suffix" do
        expect(commodity_10.declarable?).to be_falsey
      end
    end
  end

  describe '.declarable' do
    let(:commodity_80) { create(:commodity, producline_suffix: '80') }
    let(:commodity_10) { create(:commodity, producline_suffix: '10') }

    it "should return commodities ony with producline_suffix == '80'" do
      commodities = described_class.declarable
      expect(commodities).to include(commodity_80)
      expect(commodities).to_not include(commodity_10)
    end
  end

  describe '.by_code' do
    let(:commodity1) { create(:commodity, goods_nomenclature_item_id: '123') }
    let(:commodity2) { create(:commodity, goods_nomenclature_item_id: '456') }

    it 'should return commodities filtered by goods_nomenclature_item_id' do
      commodities = described_class.by_code('123')
      expect(commodities).to include(commodity1)
      expect(commodities).to_not include(commodity2)
    end
  end
end
