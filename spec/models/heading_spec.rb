require 'spec_helper'

describe Heading do
  describe '#to_param' do
    let(:heading) { create :heading }

    it 'uses first four digits of goods_nomenclature_item_id as param' do
      heading.to_param.should == heading.goods_nomenclature_item_id.first(4)
    end
  end

  describe 'associations' do
    describe 'measures' do
      let(:measure_type) { create :measure_type, measure_type_id: MeasureType::EXCLUDED_TYPES.sample }
      let(:heading)      { create :heading, :with_indent }
      let(:measure)      { create :measure, :with_base_regulation,
                                             measure_type_id: measure_type.measure_type_id,
                                             goods_nomenclature_sid: heading.goods_nomenclature_sid  }

      it 'does not include measures for excluded measure types' do
        measure_type
        measure

        heading.measures.map(&:measure_sid).should_not include measure.measure_sid
      end
    end

    describe 'commodities' do
      let!(:heading)    { create :heading }
      let!(:commodity1) { create :commodity, goods_nomenclature_item_id: "#{heading.goods_nomenclature_item_id.first(4)}100000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: nil }
      let!(:commodity2) { create :commodity, goods_nomenclature_item_id: "#{heading.goods_nomenclature_item_id.first(4)}200000",
                                         validity_start_date: 2.years.ago,
                                         validity_end_date: nil }
      let!(:commodity3) { create :commodity, goods_nomenclature_item_id: "#{heading.goods_nomenclature_item_id.first(4)}300000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: 8.years.ago }

      around(:each) do |example|
        TimeMachine.at(1.year.ago) do
          example.run
        end
      end

      it 'returns commodities matched by part of own goods nomenclature item id' do
        heading.commodities.should include commodity1
      end

      it 'returns relevant by actual time commodities' do
        heading.commodities.should include commodity2
      end

      it 'does not return commodity that is irrelevant to given time' do
        heading.commodities.should_not include commodity3
      end
    end

    describe 'chapter' do
      let!(:heading)    { create :heading }
      let!(:chapter1) { create :chapter, goods_nomenclature_item_id: "#{heading.goods_nomenclature_item_id.first(2)}00000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: nil }
      let!(:chapter2) { create :chapter, goods_nomenclature_item_id: "#{heading.goods_nomenclature_item_id.first(2)}00000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: 8.years.ago }


      around(:each) do |example|
        TimeMachine.at(1.year.ago) do
          example.run
        end
      end

      it 'returns chapter matched by part of own goods nomenclature item id' do
        heading.chapter.should eq chapter1
      end

      it 'does not return commodity that is irrelevant to given time' do
        heading.chapter.should_not eq chapter2
      end
    end
  end

  describe '#declarable' do
    context 'different commodity codes' do
      let!(:declarable_heading)     { create :heading, goods_nomenclature_item_id: "0101000000"}
      let!(:non_declarable_heading) { create :heading, goods_nomenclature_item_id: "0102000000", producline_suffix: "10" }
      let!(:commodity)              { create :commodity, goods_nomenclature_item_id: "0102000010",
                                                         producline_suffix: "80",
                                                         validity_start_date: non_declarable_heading.validity_start_date,
                                                         validity_end_date: non_declarable_heading.validity_end_date }

      it 'returns true if there are no commodities under this heading that are valid during headings validity period' do
        declarable_heading.declarable.should be_true
      end

      it 'returns false if there are commodities under the heading that are valid during headings validity period' do
        non_declarable_heading.declarable.should be_false
      end
    end

    context 'same commodity codes' do
      let!(:heading1) { create :heading, goods_nomenclature_item_id: "0101000000",
                                         producline_suffix: "10"}
      let!(:heading2) { create :heading, goods_nomenclature_item_id: "0101000000",
                                         producline_suffix: "80" }

      it 'returns true if there are no commodities under this heading that are valid during headings validity period' do
        heading1.declarable.should be_false
      end

      it 'returns false if there are commodities under the heading that are valid during headings validity period' do
        heading2.declarable.should be_true
      end
    end
  end
end
