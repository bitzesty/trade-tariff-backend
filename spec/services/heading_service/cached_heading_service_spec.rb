require 'rails_helper'

describe HeadingService::CachedHeadingService do
  
  let(:heading) { create :heading, :non_grouping,
                         :with_description }
  let(:measure_type) { create :measure_type, measure_type_id: '103' }
  let(:actual_date) { Date.current }
  
  describe '#serializable_hash' do
    describe 'applying time machine to footnotes, chapter, commodities and overview measures' do
      context 'footnotes, chapter, commodities and overview measures has valid period' do
        let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
        let!(:chapter) { create :chapter,
                                :with_section, :with_description,
                                goods_nomenclature_item_id: heading.chapter_id
        }
        let!(:commodity) { create :goods_nomenclature,
                                  :with_description,
                                  :with_indent,
                                  goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map { Random.rand(9) }.join}" }
        let!(:measure) {
          create :measure,
                 measure_type_id: measure_type.measure_type_id,
                 goods_nomenclature: commodity,
                 goods_nomenclature_sid: commodity.goods_nomenclature_sid
        }
        let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }
      
        it 'should contain chapter' do
          expect(serializable_hash.chapter).not_to equal(nil)
          expect(serializable_hash.chapter_id).not_to equal(nil)
          expect(serializable_hash.footnotes).not_to be_empty
          expect(serializable_hash.commodities).not_to be_empty
          expect(serializable_hash.commodities.first.overview_measures).not_to be_empty
        end
      end

      context 'footnotes has not valid period' do
        let!(:footnote) { create :footnote,
                                 :with_gono_association,
                                 validity_start_date: Date.current.ago(1.week),
                                 validity_end_date: Date.yesterday,
                                 goods_nomenclature_sid: heading.goods_nomenclature_sid }
        let!(:chapter) { create :chapter,
                                :with_section, :with_description,
                                goods_nomenclature_item_id: heading.chapter_id
        }
        let!(:commodity) { create :goods_nomenclature,
                                  :with_description,
                                  :with_indent,
                                  goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map { Random.rand(9) }.join}" }
        let!(:measure) {
          create :measure,
                 measure_type_id: measure_type.measure_type_id,
                 goods_nomenclature: commodity,
                 goods_nomenclature_sid: commodity.goods_nomenclature_sid
        }
        let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }

        it 'should not contain footnotes' do
          expect(serializable_hash.footnotes).to be_empty
        end
      end

      context 'chapter has not valid period' do
        let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
        let!(:chapter) { create :chapter,
                                :with_section, :with_description,
                                validity_start_date: Date.current.ago(1.week),
                                validity_end_date: Date.yesterday,
                                goods_nomenclature_item_id: heading.chapter_id
        }
        let!(:commodity) { create :goods_nomenclature,
                                  :with_description,
                                  :with_indent,
                                  goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map { Random.rand(9) }.join}" }
        let!(:measure) {
          create :measure,
                 measure_type_id: measure_type.measure_type_id,
                 goods_nomenclature: commodity,
                 goods_nomenclature_sid: commodity.goods_nomenclature_sid
        }
        let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }

        it 'should not contain chapter' do
          expect(serializable_hash.chapter).to equal(nil)
          expect(serializable_hash.chapter_id).to equal(nil)
        end
      end

      context 'commodity has not valid period' do
        let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
        let!(:chapter) { create :chapter,
                                :with_section, :with_description,
                                goods_nomenclature_item_id: heading.chapter_id
        }
        let!(:commodity) { create :goods_nomenclature,
                                  :with_description,
                                  :with_indent,
                                  validity_start_date: Date.current.ago(1.week),
                                  validity_end_date: Date.yesterday,
                                  goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map { Random.rand(9) }.join}" }
        let!(:measure) {
          create :measure,
                 measure_type_id: measure_type.measure_type_id,
                 goods_nomenclature: commodity,
                 goods_nomenclature_sid: commodity.goods_nomenclature_sid
        }
        let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }

        it 'should not contain commodities' do
          expect(serializable_hash.commodities).to be_empty
        end
      end

      context 'overview measures has not valid period' do
        let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
        let!(:chapter) { create :chapter,
                                :with_section, :with_description,
                                goods_nomenclature_item_id: heading.chapter_id
        }
        let!(:commodity) { create :goods_nomenclature,
                                  :with_description,
                                  :with_indent,
                                  goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map { Random.rand(9) }.join}" }
        let!(:measure) {
          create :measure,
                 validity_start_date: Date.current.ago(1.week),
                 validity_end_date: Date.yesterday,
                 measure_type_id: measure_type.measure_type_id,
                 goods_nomenclature: commodity,
                 goods_nomenclature_sid: commodity.goods_nomenclature_sid
        }
        let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }

        it 'should not contain overview measures' do
          expect(serializable_hash.commodities.first.overview_measures).to be_empty
        end
      end
    end
    
    describe 'building commodities tree' do
      let!(:footnote) { create :footnote, :with_gono_association, goods_nomenclature_sid: heading.goods_nomenclature_sid }
      let!(:chapter) { create :chapter,
                              :with_section, :with_description,
                              goods_nomenclature_item_id: heading.chapter_id
      }
      let!(:parent_commodity) { create :commodity,
                                :with_description,
                                :with_indent,
                                indents: 1,
                                goods_nomenclature_item_id: "#{heading.short_code}#{2.times.map { Random.rand(9) }.join}0000" }
      let!(:child_commodity) { create :commodity,
                                :with_description,
                                :with_indent,
                                indents: 2,
                                goods_nomenclature_item_id: "#{parent_commodity.goods_nomenclature_item_id.first(6)}#{4.times.map { Random.rand(9) }.join}" }
      let(:serializable_hash) { described_class.new(heading.reload, actual_date).serializable_hash }
      
      it 'should build correct commodity tree' do
        parent = serializable_hash.commodities.detect { |commodity| commodity.goods_nomenclature_sid == parent_commodity.goods_nomenclature_sid }
        child = serializable_hash.commodities.detect { |commodity| commodity.goods_nomenclature_sid == child_commodity.goods_nomenclature_sid }

        expect(parent.parent_sid).to equal(nil)
        expect(parent.leaf).to equal(false)
        expect(child.parent_sid).to equal(parent.goods_nomenclature_sid)
        expect(child.leaf).to equal(true)
      end
    end
  end
end