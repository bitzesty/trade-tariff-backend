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
  end

  describe '#declarable' do
    let!(:declarable_heading)     { create :heading, goods_nomenclature_item_id: "0101000000"}
    let!(:non_declarable_heading) { create :heading, goods_nomenclature_item_id: "0102000000" }
    let!(:commodity)              { create :commodity, goods_nomenclature_item_id: "0102000010",
                                                       validity_start_date: non_declarable_heading.validity_start_date,
                                                       validity_end_date: non_declarable_heading.validity_end_date }

    it 'returns true if there are no commodities under this heading that are valid during headings validity period' do
      declarable_heading.declarable.should be_true
    end

    it 'returns false if there are commodities under the heading that are valid during headings validity period' do
      non_declarable_heading.declarable.should be_false
    end
  end
end
