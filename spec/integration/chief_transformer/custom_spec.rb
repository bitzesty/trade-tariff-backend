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
        expect { goods_nomenclature.reload }.to raise_error
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

  describe 'Scenario: MFCM update fails due to conformance validation (ME8)' do
    let!(:gono) { create :goods_nomenclature, :declarable, :with_indent,
                                             goods_nomenclature_sid: 91900,
                                             goods_nomenclature_item_id: '5607509090',
                                             producline_suffix: 80,
                                             validity_start_date: Date.new(2010,1,1),
                                             validity_end_date: Date.new(2013,2,28) }
    let!(:measure) { create :measure, :national, measure_sid: -41534,
                                                 measure_type_id: 'VTS',
                                                 goods_nomenclature: gono,
                                                 goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                 goods_nomenclature_item_id: gono.goods_nomenclature_item_id,
                                                 validity_start_date: DateTime.new(2007,10,1,0,0),
                                                 validity_end_date: Date.new(2013,2,28),
                                                 tariff_measure_number: '12110985' }

    let!(:mfcm) { create :mfcm, msrgp_code: 'VT',
                                msr_type: 'S',
                                tty_code: 'B00',
                                fe_tsmp: DateTime.new(2013,5,14,14,14),
                                le_tsmp: DateTime.new(2013,5,14,14,28),
                                cmdty_code: '5607509090',
                                tar_msr_no: nil,
                                amend_indicator: 'U' }


    let!(:measure_type) { create :measure_type, measure_type_id: 'VTS', validity_start_date: Date.today.ago(10.years) }

    it 'will not raise validation exception' do
      expect { ChiefTransformer.instance.invoke }.not_to raise_error
    end

    it 'will update measure validity dates' do
      ChiefTransformer.instance.invoke

      measure.reload.validity_end_date.should eq mfcm.le_tsmp
    end

    it 'will mark measure as invalidated' do
      ChiefTransformer.instance.invoke

      expect(measure.reload).to be_invalidated
    end
  end

  describe 'Scenario: single CHIEF update contains MFCM Insert and Update operations' do
    let!(:gono) { create :goods_nomenclature, :declarable, :with_indent,
                                             goods_nomenclature_sid: 97701,
                                             goods_nomenclature_item_id: '1104291710',
                                             producline_suffix: 80,
                                             validity_start_date: Date.new(2013,7,1),
                                             validity_end_date: nil}
    let!(:mfcm_insert) { create :mfcm, msrgp_code: 'VT',
                                msr_type: 'Z',
                                tty_code: 'B00',
                                fe_tsmp: DateTime.new(2013,7,10,10,27,00),
                                le_tsmp: DateTime.new(2013,7,10,10,28,00),
                                audit_tsmp: DateTime.new(2013,7,10,10,26,00),
                                cmdty_code: '1104291710',
                                tar_msr_no: nil,
                                origin: "2013-07-11_KBT009(13192).txt",
                                amend_indicator: 'I' }
    let!(:mfcm_update) { create :mfcm, msrgp_code: 'VT',
                                msr_type: 'Z',
                                tty_code: 'B00',
                                fe_tsmp: DateTime.new(2013,7,10,10,28,00),
                                audit_tsmp: DateTime.new(2013,7,10,10,26,00),
                                le_tsmp: nil,
                                cmdty_code: '1104291710',
                                tar_msr_no: nil,
                                origin: "2013-07-11_KBT009(13192).txt",
                                amend_indicator: 'U' }

    let!(:geographical_area)  { create :geographical_area, :erga_omnes }
    let!(:tame) { create :tame,
                  fe_tsmp: DateTime.new(2010,2,22,12,27),
                  msrgp_code: 'VT',
                  msr_type: 'Z',
                  tty_code: 'B00',
                  le_tsmp: nil }

    before { ChiefTransformer.instance.invoke }

    it 'creates a short lived VTZ measure for 1104291710' do
      expect(
        Measure.national.where(
          goods_nomenclature_item_id: '1104291710',
          validity_start_date: DateTime.new(2013,7,10,10,27),
          validity_end_date: DateTime.new(2013,7,10,10,28),
          measure_type_id: 'VTZ'
        ).any?
      ).to be_true
    end

    it 'creates an open VTZ measure for 1104291710' do
      expect(
        Measure.national.where(
          goods_nomenclature_item_id: '1104291710',
          validity_start_date: DateTime.new(2013,7,10,10,28),
          validity_end_date: nil,
          measure_type_id: 'VTZ'
        ).any?
      ).to be_true
    end
  end
end
