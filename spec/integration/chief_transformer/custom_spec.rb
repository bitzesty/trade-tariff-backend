require 'spec_helper'
require 'goods_nomenclature'
require 'chief_transformer'
require 'tariff_importer'

describe 'CHIEF: Custom scenarions' do
  before(:all) { preload_standing_data }
  after(:all)  { clear_standing_data }

  # Based on real data
  describe 'Scenario: TARIC update invalidates CHIEF measures' do
    let!(:measure_type)       { create :measure_type, measure_type_id: 'CVD' }
    let!(:geographical_area)  { create :geographical_area, :erga_omnes }
    let!(:goods_nomenclature) { create :goods_nomenclature, :declarable,
                                                            :with_indent,
                                                            goods_nomenclature_sid: 70180,
                                                            validity_start_date: DateTime.parse("1998-07-14 00:00:00 -0700"),
                                                            validity_end_date: nil }
    let!(:goods_nomenclature_indent) { create :goods_nomenclature_indent, number_indents: 10,
                                                                          validity_start_date: DateTime.parse("1998-07-14 00:00:00 -0700"),
                                                                          goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                          goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id }
    let(:national_measure) { create :measure, :national, :with_base_regulation,
                                                         measure_type: measure_type.measure_type_id,
                                                         geographical_area_id: geographical_area.geographical_area_id,
                                                         geographical_area_sid: geographical_area.geographical_area_sid,
                                                         goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                         goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id,
                                                         tariff_measure_number: goods_nomenclature.goods_nomenclature_item_id,
                                                         validity_start_date: DateTime.parse("2012-03-01 00:00:00 +0200")   }

    specify 'national measure is valid before update' do
      national_measure.valid?.should be_true
    end

    context 'Taric update occurs' do
      let(:transaction_id) { 13565498 }

      # Update goods nomenclature effectively leaving national measure invalid!
      # As goods_nomenclature now does not span the validity period of national_measure (ME8)
      def perform_transaction()
        transaction_xml = Nokogiri::XML.parse(%Q{
        <oub:record>
          <oub:transaction.id>#{transaction_id}</oub:transaction.id>
          <oub:record.code>400</oub:record.code>
          <oub:subrecord.code>00</oub:subrecord.code>
          <oub:record.sequence.number>199</oub:record.sequence.number>
          <oub:update.type>1</oub:update.type>
          <oub:goods.nomenclature>
            <oub:goods.nomenclature.sid>70180</oub:goods.nomenclature.sid>
            <oub:goods.nomenclature.item.id>1604141620</oub:goods.nomenclature.item.id>
            <oub:producline.suffix>10</oub:producline.suffix>
            <oub:validity.start.date>1998-07-14</oub:validity.start.date>
            <oub:validity.end.date>2011-12-31</oub:validity.end.date>
            <oub:statistical.indicator>0</oub:statistical.indicator>
          </oub:goods.nomenclature>
        </oub:record>
        })
        transaction_xml.remove_namespaces!

        TaricImporter::Strategies::GoodsNomenclature.new(transaction_xml).process!
      end

      specify 'sets national measures invalidate_by to Taric transaction number' do
        national_measure

        perform_transaction

        national_measure.reload.invalidated_by.should eq transaction_id
      end
    end
  end
end
