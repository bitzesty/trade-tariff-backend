require 'rails_helper'

describe ImportSearchReferences do
  include FakeFS::SpecHelpers

  let(:file_name) { 'green-pages.csv' }

  describe '.reload' do
    context 'existing entries present in search reference table' do
      let(:search_reference) { create :search_reference }

      before {
        create_file(file_name)
      }

      it 'truncates existing SearchReference table entries' do
        ImportSearchReferences.reload(file_name)

        expect(SearchReference.count).to eq 0
      end
    end
  end

  describe '#run' do
    let(:task)     { described_class.new(file_name) }

    context 'file contains entries for Chapters' do
      before {
        create_file(file_name, "Example;Chapter 01")
      }

      context 'chapter exists' do
        let!(:chapter) { create :chapter, goods_nomenclature_item_id: "0100000000" }

        it 'creates SearchReference entries for Chapters' do
          task.run

          expect(SearchReference.for_chapter(chapter).any?).to be_truthy
        end
      end

      context 'chapter does not exist' do
        it 'does not create SearchReference entries for Chapters' do
          task.run

          expect(SearchReference.for_chapters.any?).to be_blank
        end
      end
    end

    context 'file contains entries for Headings' do
      before {
        create_file(file_name, "Example;01.02")
      }

      context 'heading is present' do
        let!(:heading)  { create :heading, goods_nomenclature_item_id: "0102000000" }

        it 'creates SearchReference entries for Headings' do
          task.run

          expect(SearchReference.for_heading(heading).any?).to be_truthy
        end
      end

      context 'heading is missing' do
        it 'does not create SearchReference entries for Headings' do
          task.run

          expect(SearchReference.for_headings.any?).to be_blank
        end
      end
    end

    context 'file contains entries for Sections' do
      before {
        create_file(file_name, "Example;Section 1")
      }

      context 'section is present' do
        let!(:section) { create :section, position: "1" }

        it 'creates SearchReference entries for Sections' do
          task.run

          expect(SearchReference.for_section(section).any?).to be_truthy
        end
      end

      context 'section is missing' do
        it 'does not create SearchReference entries for Sections' do
          task.run

          expect(SearchReference.for_sections.any?).to be_blank
        end
      end
    end

    context 'file contains several entries (Chapter + Heading)' do
      let!(:chapter)  { create :chapter }
      let!(:heading)  { create :heading }

      before {
        create_file(file_name, "Example;Chapter #{chapter.short_code} OR #{heading.short_code.first(2)}.#{heading.short_code.last(2)}")

        task.run
      }

      it 'creates SearchReference entry for Chapter' do
        expect(SearchReference.for_chapter(chapter).any?).to be_truthy
      end

      it 'creates SearchReference entry for Heading' do
        expect(SearchReference.for_heading(heading).any?).to be_truthy
      end
    end

    context 'file contains no entry of known entity pattern' do
      before {
        create_file(file_name, " ... ")
      }

      it 'does not create any SearchReference entities' do
        task.run

        expect(SearchReference.count).to be_zero
      end
    end
  end
end
