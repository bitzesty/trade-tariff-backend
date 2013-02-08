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
    let!(:geographical_area)  { build :geographical_area, :erga_omnes }
    let!(:goods_nomenclature) { create :goods_nomenclature, :declarable,
                                                            :with_indent,
                                                            goods_nomenclature_item_id: '1604141620',
                                                            goods_nomenclature_sid: 70180,
                                                            producline_suffix: 80,
                                                            validity_start_date: DateTime.parse("1998-07-14 00:00:00 -0700"),
                                                            validity_end_date: nil }
    let!(:goods_nomenclature_indent) { create :goods_nomenclature_indent, number_indents: 10,
                                                                          validity_start_date: DateTime.parse("1998-07-14 00:00:00 -0700"),
                                                                          goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                          goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id }
    let(:national_measure) { create :measure, :national, measure_type_id: measure_type.measure_type_id,
                                                         goods_nomenclature: goods_nomenclature,
                                                         geographical_area: geographical_area,
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
        transaction_record = {
          'transaction.id' => transaction_id,
          'record.code' => '400',
          'subrecord.code' => '00',
          'record.sequence.number' => '199',
          'update.type' => '1',
          'goods.nomenclature' => {
            'goods.nomenclature.sid' => '70180',
            'goods.nomenclature.item.id' => '1604141620',
            'producline.suffix' => '80',
            'validity.start.date' => '1998-07-14',
            'validity.end.date' => '2011-12-31',
            'statistical.indicator' => '0'
          }

        }

        TaricImporter::RecordProcessor.new(transaction_record).process!
      end

      specify 'sets national measures invalidate_by to Taric transaction number' do
        national_measure

        perform_transaction

        national_measure.reload.invalidated_by.should eq transaction_id
        national_measure.valid?.should be_true
      end
    end
  end

  describe 'Scenario: TARIC deletion invalidates CHIEF measures' do
    let!(:measure_type)       { create :measure_type, measure_type_id: 'CVD' }
    let!(:geographical_area)  { build :geographical_area, :erga_omnes }
    let!(:goods_nomenclature) { create :goods_nomenclature, :declarable,
                                                            :with_indent,
                                                            goods_nomenclature_item_id: "0305720040",
                                                            goods_nomenclature_sid: 96196,
                                                            validity_start_date: DateTime.parse("2012-01-01 00:00:00 -0700"),
                                                            validity_end_date: nil }
    let!(:goods_nomenclature_indent) { create :goods_nomenclature_indent, number_indents: 10,
                                                                          validity_start_date: DateTime.parse("2012-01-01 00:00:00 -0700"),
                                                                          goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                          goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id }
    let(:national_measure) { create :measure, :national, measure_type_id: measure_type.measure_type_id,
                                                         goods_nomenclature: goods_nomenclature,
                                                         geographical_area: geographical_area,
                                                         tariff_measure_number: goods_nomenclature.goods_nomenclature_item_id,
                                                         validity_start_date: DateTime.parse("2012-07-01 00:00:00 +0200")   }

    specify 'national measure is valid before update' do
      national_measure.valid?.should be_true
    end

    context 'Taric update occurs' do
      let(:transaction_id) { 13590603 }

      # Goods Nomenclature deletion Makes national measures invalid.
      def perform_transaction()
        transaction_record = {
          'transaction.id' => transaction_id,
          'record.code' => '400',
          'subrecord.code' => '00',
          'record.sequence.number' => '00',
          'update.type' => '2',
          'goods.nomenclature' => {
            'goods.nomenclature.sid' => '96196',
            'goods.nomenclature.item.id' => '0305720040',
            'producline.suffix' => '80',
            'validity.start.date' => '2012-01-01',
            'statistical.indicator' => '0'
          }
        }

        TaricImporter::RecordProcessor.new(transaction_record).process!
      end

      before {
        national_measure

        perform_transaction
      }

      specify 'sets national measures invalidate_by to Taric transaction number' do
        national_measure.reload.invalidated_by.should eq transaction_id
        national_measure.valid?.should be_true
      end

      specify 'deletes goods nomenclature' do
        expect { goods_nomenclature.reload }.to raise_error Sequel::Error
      end
    end
  end

  # Based on real data
  describe 'Scenario: TAME deletion yields national measure invalid' do
    let!(:gono) { create :goods_nomenclature, :with_indent,
                                             goods_nomenclature_sid: 86487,
                                             goods_nomenclature_item_id: '1211908500',
                                             producline_suffix: 80,
                                             validity_start_date: Date.new(2007,1,1),
                                             validity_end_date: Date.new(2012,12,13) }
    let!(:measure) { create :measure, :national, measure_sid: -262016,
                                                 measure_type_id: 'COE',
                                                 goods_nomenclature: gono,
                                                 validity_start_date: DateTime.new(2012,7,25,11,1),
                                                 validity_end_date: nil,
                                                 tariff_measure_number: '12110985' }
    let!(:measure_type) { create :measure_type, measure_type_id: 'COE' }
    let!(:tame) { create :tame, fe_tsmp: DateTime.new(2013,1,1),
                                msrgp_code: 'HO',
                                msr_type: 'CON',
                                tty_code: nil,
                                tar_msr_no: '12110985',
                                le_tsmp: nil,
                                processed: false,
                                amend_indicator: 'X' }
    before {
      ChiefTransformer.instance.invoke
    }

    it 'should set measure validity end date to gono validity end date' do
      # so that ME8 validation on Measure is kept valid
      measure.reload.validity_end_date.should eq gono.validity_end_date
      measure.validity_end_date.should_not eq tame.fe_tsmp
    end
  end
end
