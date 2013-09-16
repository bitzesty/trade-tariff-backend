require 'spec_helper'

describe SearchReference do
  describe '#referenced_entity' do
    context "matching heading regexp" do
      let(:heading) { create :heading, goods_nomenclature_item_id: "1212000000" }
      let(:search_reference) { create :search_reference, heading_id: heading.short_code }

      it 'returns referenced Heading object' do
        heading

        expect(search_reference.referenced_entity).to eq heading
      end
    end

    context 'matching Chapter regexp' do
      let(:chapter) { create :chapter, goods_nomenclature_item_id: "1200000000" }
      let(:search_reference) { create :search_reference, chapter_id: chapter.short_code, heading: nil }

      it 'returns Chapter object' do
        chapter

        expect(search_reference.referenced_entity).to eq chapter
      end
    end

    context 'matching Seciont regexp' do
      let(:section)          { create :section, position: 12 }
      let(:search_reference) { create :search_reference, section: section, heading: nil }

      it 'returns Section object' do
        section

        expect(search_reference.referenced_entity).to eq section
      end
    end
  end

  describe "#to_indexed_json" do
    context 'when there is a valid referenced object' do
      let(:section) { create :section, position: 12 }
      let(:search_reference) { create :search_reference, section_id: section.id, heading: nil }
      let(:pattern) {
        {
          title: search_reference.title,
          reference_class: String,
          reference: {
            class: 'Section'
          }.ignore_extra_keys!
        }
      }

      it 'returns rendered referenced entity as json' do
        section

        expect(search_reference.to_indexed_json).to match_json_expression pattern
      end
    end

    context 'when there is no valid referenced object' do
      let(:search_reference) {
        create :search_reference,
               section_id: nil,
               chapter_id: nil,
               heading_id: nil
      }

      it 'returns blank json hash' do
        expect(search_reference.to_indexed_json).to eq "{}"
      end
    end
  end
end
