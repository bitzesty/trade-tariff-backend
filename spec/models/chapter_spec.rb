require 'rails_helper'

describe Chapter do
  describe 'associations' do
    describe 'headings' do
      let!(:chapter)  { create :chapter }
      let!(:heading1) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}10000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: nil }
      let!(:heading2) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000",
                                         validity_start_date: 2.years.ago,
                                         validity_end_date: nil }
      let!(:heading3) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}30000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: 8.years.ago }
      let!(:heading4) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}40000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: nil }
      let!(:hidden_gono)  { create :hidden_goods_nomenclature, goods_nomenclature_item_id: heading4.goods_nomenclature_item_id }

      around(:each) do |example|
        TimeMachine.at(1.year.ago) do
          example.run
        end
      end

      it 'returns headings matched by part of own goods nomenclature item id' do
        expect(chapter.headings).to include heading1
      end

      it 'returns relevant by actual time headings' do
        expect(chapter.headings).to include heading2
      end

      it 'does not return heading that is irrelevant to given time' do
        expect(chapter.headings).to_not include heading3
      end

      it 'does not include hidden commodity' do
        expect(chapter.headings).to_not include heading4
      end
    end
  end

  describe "#number_indents" do
    let(:chapter) { build :chapter }

    it 'defaults to zero' do
      expect(chapter.number_indents).to eq 0
    end
  end

  describe '#to_param' do
    let(:chapter) { create :chapter }

    it 'uses first two digits of goods_nomenclature_item_id as param' do
      expect(chapter.to_param).to eq chapter.goods_nomenclature_item_id.first(2)
    end
  end

  describe '#changes' do
    let(:chapter) { create :chapter }

    it 'returns Sequel Dataset' do
      expect(chapter.changes).to be_kind_of Sequel::Dataset
    end

    context 'with Chapter changes' do
      let!(:chapter) { create :chapter, operation_date: Date.today }

      it 'includes Chapter changes' do
        expect(
          chapter.changes.select { |change|
            change.oid == chapter.oid &&
            change.model == Chapter
          }
        ).to be_present
      end

      context 'with Heading changes' do
        let!(:heading) {
          create :heading,
                 operation_date: Date.today,
                 goods_nomenclature_item_id: "#{chapter.short_code}01000000"
        }

        it 'includes Heading changes' do
          expect(
            chapter.changes.select { |change|
              change.oid == heading.oid &&
              change.model == Heading
            }
          ).to be_present
        end

        context 'with associated Commodity changes' do
          let!(:commodity) {
            create :commodity,
                   operation_date: Date.today,
                   goods_nomenclature_item_id: "#{heading.short_code}000001"
          }

          it 'includes Commodity changes' do
            expect(
              chapter.changes.select { |change|
                change.oid == commodity.oid &&
                change.model == Commodity
              }
            ).to be_present
          end

          context 'with associated Measure (through Commodity) changes' do
            let!(:measure)   {
              create :measure,
                     goods_nomenclature: commodity,
                     goods_nomenclature_item_id: commodity.goods_nomenclature_item_id,
                     operation_date: Date.today
            }

            it 'includes Measure changes' do
              expect(
                heading.changes.select { |change|
                  change.oid == measure.oid &&
                  change.model == Measure
                }
              ).to be_present
            end
          end
        end
      end
    end
  end

  describe '.by_code' do
    let!(:chapter1) { create(:chapter, goods_nomenclature_item_id: '1200000000') }
    let!(:chapter2) { create(:chapter, goods_nomenclature_item_id: '2100000000') }

    it 'should return chapters filtered by goods_nomenclature_item_id' do
      chapters = described_class.by_code('12')
      expect(chapters).to include(chapter1)
      expect(chapters).to_not include(chapter2)
    end
  end

  describe '#to_param' do
    let!(:chapter)  { create :chapter, goods_nomenclature_item_id: '1200000000' }

    it 'should return short_code' do
      expect(chapter.to_param).to eq(chapter.short_code)
    end
  end

  describe 'first & last heading' do
    let!(:chapter)  { create :chapter, goods_nomenclature_item_id: '1200000000' }
    let!(:heading1) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}10000000",
                             validity_end_date: nil }
    let!(:heading2) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000",
                             validity_end_date: nil }
    let!(:heading3) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}30000000",
                             validity_end_date: nil }

    describe '#first_heading' do
      it 'should return first heading ordered by goods_nomenclature_item_id' do
        expect(chapter.first_heading).to eq(heading1)
      end
    end

    describe '#last_heading' do
      it 'should return last heading ordered by goods_nomenclature_item_id' do
        expect(chapter.last_heading).to eq(heading3)
      end
    end

    describe '#headings_from' do
      it 'should return first heading short_code' do
        expect(chapter.headings_from).to eq(heading1.short_code)
      end
    end

    describe '#headings_to' do
      it 'should return last heading short_code' do
        expect(chapter.headings_to).to eq(heading3.short_code)
      end
    end
  end

  describe '#short_code' do
    let!(:chapter)  { create :chapter, goods_nomenclature_item_id: '1200000000' }

    it 'should return first 2 chars of goods_nomenclature_item_id' do
      expect(chapter.short_code).to eq('12')
    end
  end

  describe '#relevant_headings' do
    let!(:chapter)  { create :chapter, goods_nomenclature_item_id: '1200000000' }

    it 'should include short_code' do
      expect(chapter.send(:relevant_headings)).to include(chapter.short_code)
    end

    it 'should include suffix __000000' do
      expect(chapter.send(:relevant_headings)).to include('__000000')
    end

    it 'should have valid format' do
      expect(chapter.send(:relevant_headings)).to eq("#{chapter.short_code}__000000")
    end
  end

  describe '#relevant_commodities' do
    let!(:chapter)  { create :chapter, goods_nomenclature_item_id: '1200000000' }

    it 'should include short_code' do
      expect(chapter.send(:relevant_commodities)).to include(chapter.short_code)
    end

    it 'should include suffix __000000' do
      expect(chapter.send(:relevant_commodities)).to include('________')
    end

    it 'should have valid format' do
      expect(chapter.send(:relevant_commodities)).to eq("#{chapter.short_code}________")
    end
  end
end
