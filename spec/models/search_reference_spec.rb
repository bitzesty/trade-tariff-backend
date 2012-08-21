require 'spec_helper'

describe SearchReference do
  describe '#referenced_entity' do
    context "matching heading regexp" do
      let(:heading) { create :heading, goods_nomenclature_item_id: "1212000000" }
      let(:search_reference) { create :search_reference, reference: "12.12" }

      it 'returns referenced Heading object' do
        heading

        search_reference.referenced_entity.should == heading
      end
    end

    context 'matching Chapter regexp' do
      let(:chapter) { create :chapter, goods_nomenclature_item_id: "1200000000" }
      let(:search_reference) { create :search_reference, reference: "Chapter 12" }

      it 'returns Chapter object' do
        chapter

        search_reference.referenced_entity.should == chapter
      end
    end

    context 'matching Seciont regexp' do
      let(:section) { create :section, position: 12 }
      let(:search_reference) { create :search_reference, reference: "Section 12" }

      it 'returns Section object' do
        section

        search_reference.referenced_entity.should == section
      end
    end
  end

  describe "#to_indexed_json" do
    context 'when there is a valid referenced object' do
      let(:section) { create :section, position: 12 }
      let(:search_reference) { create :search_reference, reference: "Section 12" }
      let(:pattern) {
        {
          title: search_reference.title,
          reference: {
            class: 'Section'
          }.ignore_extra_keys!
        }
      }

      it 'returns rendered referenced entity as json' do
        section

        search_reference.to_indexed_json.should match_json_expression pattern
      end
    end

    context 'when there is no valid referenced object' do
      let(:search_reference) { create :search_reference, reference: "Section 12" }

      it 'returns blank json hash' do
        search_reference.to_indexed_json.should == "{}"
      end
    end
  end
end
