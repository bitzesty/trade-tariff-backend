require 'spec_helper'

describe ChiefTransformer::Processor::TameDelete do
  before(:all) { preload_standing_data }
  after(:all)  { clear_standing_data }

  let(:sample_operation_date) { Date.new(2013,8,5) }

  let(:chief_update) {
    create :chief_update, :applied, issue_date: sample_operation_date
  }

  describe '#process' do
    let!(:tame) { create(:tame, amend_indicator: "X",
                                fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                tar_msr_no: '0101010100',
                                msrgp_code: "VT",
                                msr_type: "S",
                                tty_code: "813",
                                adval_rate: 15.000,
                                origin: chief_update.filename) }

    context 'has relevant, non-terminated national measures' do
      context 'associated to non open ended goods nomenclature' do
        context 'TAME first effective date greater than goods nomenclature validity end date' do
          let(:goods_nomenclature) {
            create :commodity,
              goods_nomenclature_item_id: '0101010100' ,
              validity_start_date: DateTime.parse("2006-1-15 11:00:00"),
              validity_end_date: DateTime.parse("2007-12-15 11:00:00")
          }

          let!(:measure) {
            create :measure, :national,
              validity_start_date: DateTime.parse("2006-11-15 11:00:00"),
              validity_end_date: nil,
              goods_nomenclature: goods_nomenclature,
              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
              goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id,
              tariff_measure_number: '0101010100',
              measure_type_id: 'VTS'
          }

          before { ChiefTransformer::Processor::TameDelete.new(tame).process }

          it 'ends measure setting validity end date to goods nomenclature validity end date' do
            expect(
              Measure::Operation.where(
                goods_nomenclature_item_id: '0101010100',
                national: true,
                measure_type_id: 'VTS',
                operation: 'U',
                validity_end_date: goods_nomenclature.validity_end_date,
                operation_date: sample_operation_date
              ).where(
                Sequel.~(
                  justification_regulation_id: nil,
                  justification_regulation_role: nil
                )
              ).one?
            ).to be_true
          end
        end

        context 'TAME first effective date less than goods nomenclature validity end date' do
          let(:goods_nomenclature) {
            create :commodity,
              goods_nomenclature_item_id: '0101010100' ,
              validity_start_date: DateTime.parse("2006-1-15 11:00:00"),
              validity_end_date: DateTime.parse("2010-12-15 11:00:00")
          }

          let!(:measure) {
            create :measure, :national,
              validity_start_date: DateTime.parse("2006-11-15 11:00:00"),
              validity_end_date: nil,
              goods_nomenclature: goods_nomenclature,
              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
              goods_nomenclature_item_id: goods_nomenclature.goods_nomenclature_item_id,
              tariff_measure_number: '0101010100',
              measure_type_id: 'VTS'
          }

          before { ChiefTransformer::Processor::TameDelete.new(tame).process }

          it 'ends measure setting validity end date to TAME first effective date' do
            expect(
              Measure::Operation.where(
                goods_nomenclature_item_id: '0101010100',
                national: true,
                measure_type_id: 'VTS',
                operation: 'U',
                validity_end_date: tame.fe_tsmp,
                operation_date: sample_operation_date
              ).where(
                Sequel.~(
                  justification_regulation_id: nil,
                  justification_regulation_role: nil
                )
              ).one?
            ).to be_true
          end
        end
      end

      context 'associated to open ended goods nomenclature' do
        let!(:measure) {
          create :measure, :national,
            validity_start_date: DateTime.parse("2006-11-15 11:00:00"),
            validity_end_date: nil, # not terminated
            goods_nomenclature_item_id: '0101010100',
            tariff_measure_number: '0101010100',
            measure_type_id: 'VTS'
        }

        before { ChiefTransformer::Processor::TameDelete.new(tame).process }

        it 'ends measure setting validity end date to TAME first effective date' do
          expect(
            Measure::Operation.where(
              goods_nomenclature_item_id: '0101010100',
              national: true,
              measure_type_id: 'VTS',
              operation: 'U',
              validity_end_date: tame.fe_tsmp,
              operation_date: sample_operation_date
            ).where(
              Sequel.~(
                justification_regulation_id: nil,
                justification_regulation_role: nil
              )
            ).one?
          ).to be_true
        end
      end
    end

    context 'has relevant, terminated national measures' do
      let!(:tame) { create(:tame, amend_indicator: "X",
                                  fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                  tar_msr_no: '0101010100',
                                  msrgp_code: "VT",
                                  msr_type: "S",
                                  tty_code: "813",
                                  adval_rate: 15.000,
                                  origin: chief_update.filename) }

      let!(:measure) {
        create :measure, :national,
          validity_start_date: DateTime.parse("2006-11-15 11:00:00"),
          validity_end_date: DateTime.parse("2008-11-15 11:00:00"), # terminated
          goods_nomenclature_item_id: '0101010100',
          tariff_measure_number: '0101010100',
          measure_type_id: 'VTS'
      }

      before { ChiefTransformer::Processor::TameDelete.new(tame).process }

      it 'does not update Measure validity period' do
        expect(
          Measure::Operation.where(
            goods_nomenclature_item_id: '0101010100',
            national: true,
            measure_type_id: 'VTS',
            operation: 'C',
            validity_start_date: measure.validity_start_date,
            validity_end_date: measure.validity_end_date,
            justification_regulation_id: nil,
            justification_regulation_role: nil
          ).one?
        ).to be_true
      end
    end
  end
end
