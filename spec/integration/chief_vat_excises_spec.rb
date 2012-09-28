require 'spec_helper'
require 'chief_transformer'

describe "CHIEF: VAT and Excises" do
  before(:all) { preload_standing_data }
  after(:all)  { clear_standing_data }

  context "TAME Initial Load Scenario 1: VAT measures" do
    let!(:tame1) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", adval_rate: BigDecimal('17.5')) }
    let!(:tame2) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "VT", msr_type: "A", tty_code: "813", adval_rate: BigDecimal('5')) }
    let!(:tame3) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "VT", msr_type: "Z", tty_code: "B00") }
    let!(:tame4) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "VT", msr_type: "E", tty_code: "B00") }

    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "0101010100") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-06-01 00:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", le_tsmp: DateTime.parse("2008-12-31 23:14:10"), cmdty_code: "0202020200") }
    let!(:mfcm3){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-11-15 11:00:00"), msrgp_code: "VT", msr_type: "A", tty_code: "813", cmdty_code: "0303030300") }
    let!(:mfcm4){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "VT", msr_type: "Z", tty_code: "B00", cmdty_code: "0404040400") }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before do
      ChiefTransformer.instance.invoke(:initial_load)
    end

    it "should create measure for 0101010100" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100", validity_start_date: DateTime.parse("2005-01-01 11:00:00")).take
      m.measure_components.first.duty_amount.should == 17.5
    end

    it "should create measure for 0202020200" do
      m = Measure.where(goods_nomenclature_item_id: "0202020200", validity_start_date: DateTime.parse("2006-06-01 00:00:00"), validity_end_date: DateTime.parse("2008-12-31 23:14:10")).take
      m.measure_components.first.duty_amount.should == 17.5
    end

    it "should create measure for 0303030300" do
      m = Measure.where(goods_nomenclature_item_id: "0303030300", validity_start_date: DateTime.parse("2007-11-15 11:00:00")).take
      m.measure_components.first.duty_amount.should == 5
    end

    it "should create measure for 0404040400" do
      m = Measure.where(goods_nomenclature_item_id: "0404040400", validity_start_date: DateTime.parse("2007-10-01 00:00:00")).take
      m.measure_components.first.duty_amount.should == 0
    end
  end

  context "TAME Initial Load Scenario 2: VAT seasonal goods and pseudo commodity codes" do
    let!(:tame1) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", adval_rate: BigDecimal('17.5')) }

    let!(:mfcm1){ build(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "01010101A00") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-06-01 00:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "0101010100") }
    let!(:mfcm3){ build(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-06-01 00:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "9920990000") }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    it "should not save invalid mfcm records" do
      mfcm1.should_not be_valid
      mfcm3.should_not be_valid
    end

    it "should create the following measures" do
      ChiefTransformer.instance.invoke(:initial_load)
      m = Measure.where(goods_nomenclature_item_id: "0101010100", validity_start_date: DateTime.parse("2006-06-01 00:00:00")).take
      m.measure_components.first.duty_amount.should == 17.5
    end
  end

  context "TAMF Initial Load Scenario 1: Excise measures" do
    # Excise measures with no duty amount specified in CHIEF will results in a Taric measure with duty amount set to 0%.
    # The start and end date of the Taric measure is set to the minimum common interval of the related MFCM, TAME and TAMF records.

    let!(:tame1) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423") }
    let!(:tame2) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "611") }
    let!(:tame3) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "EX", msr_type: "EXL", tty_code: "520", le_tsmp: DateTime.parse("2007-12-31 23:50:00")) }
    let!(:tame4) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "551") }

    let!(:tamf1) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", spfc1_rate: BigDecimal("1.7799")) }
    let!(:tamf2) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "611", adval1_rate: BigDecimal("22.000"), spfc1_rate: BigDecimal("108.6500")) }
    let!(:tamf3) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "EX", msr_type: "EXL", tty_code: "520", spfc1_rate: BigDecimal("0.6007")) }
    let!(:tamf4) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "551") }

    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", cmdty_code: "0101010100") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-06-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "611", cmdty_code: "0202020200") }
    let!(:mfcm3){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-11-15 11:00:00"), msrgp_code: "EX", msr_type: "EXL", tty_code: "520", cmdty_code: "0303030300", le_tsmp: DateTime.parse("2007-12-01 00:00:00")) }
    let!(:mfcm4){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "EX", msr_type: "EXL", tty_code: "520", cmdty_code: "0404040400") }
    let!(:mfcm5){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 00:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "551", cmdty_code: "0505050500") }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before do
      ChiefTransformer.instance.invoke(:initial_load)
    end

    it "should create measures for 0101010100" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100", validity_start_date: DateTime.parse("2005-01-01 11:00:00")).first
      m.goods_nomenclature_item_id.should == "0101010100"
      m.measure_components.first.duty_amount.should == 1.7799
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end

    it "should create measures for 0202020200" do
      m = Measure.where(goods_nomenclature_item_id: "0202020200", validity_start_date: DateTime.parse("2006-06-01 00:00:00")).first
      m.goods_nomenclature_item_id.should == "0202020200"
      m.measure_components.first.duty_amount.should == 22.0
      m.measure_components.second.duty_amount.should == 108.650
      m.measure_components.second.monetary_unit_code.should == 'GBP'
      # TODO 22%+108.650GBP/1000 items
    end

    it "should create measures for 0303030300" do
      m = Measure.where(goods_nomenclature_item_id: "0303030300", validity_start_date: DateTime.parse("2007-11-15 11:00:00")).first
      m.goods_nomenclature_item_id.should == "0303030300"
      m.validity_end_date.should == Time.parse("2007-12-01 00:00:00")
      m.measure_components.first.duty_amount.should == 0.6007
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end

    it "should create measures for 0404040400" do
      m = Measure.where(goods_nomenclature_item_id: "0404040400", validity_start_date: DateTime.parse("2007-10-01 00:00:00")).first
      m.goods_nomenclature_item_id.should == "0404040400"
      m.validity_end_date.should == Time.parse("2007-12-31 23:50:00")
      m.measure_components.first.duty_amount.should == 0.6007
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end

    it "should create measures for 0505050500" do
      m = Measure.where(goods_nomenclature_item_id: "0505050500", validity_start_date: DateTime.parse("2005-01-01 00:00:00")).first
      m.goods_nomenclature_item_id.should == "0505050500"
      m.measure_components.first.duty_amount.should == 0
    end
  end

  context "TAMF Initial Load Scenario 2: Excise measures different countries" do
    let!(:in) { create(:geographical_area, geographical_area_id: "IN", geographical_area_sid: 154, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:us) { create(:geographical_area, geographical_area_id: "US", geographical_area_sid: 103, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:cn) { create(:geographical_area, geographical_area_id: "CN", geographical_area_sid: 439, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }

    let!(:tame1) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423") }

    let!(:tamf1) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", cntry_orig: "US", spfc1_rate: BigDecimal("1.7799")) }
    let!(:tamf2) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", cntry_orig: "CN", spfc1_rate: BigDecimal("2.3000")) }
    let!(:tamf3) { create(:tamf, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", cntry_orig: "IN", spfc1_rate: BigDecimal("2.0000")) }

    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2005-01-01 11:00:00"), msrgp_code: "EX", msr_type: "EXF", tty_code: "423", cmdty_code: "0101010100") }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before { ChiefTransformer.instance.invoke(:initial_load) }

    # If there are several TAMF records with values in CNTRYORIG or CNGPCODE this will result in that a Taric measure is created for each country/country group.
    it "should create measures for US" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        geographical_area: "US",
                        validity_start_date: DateTime.parse("2005-01-01 11:00:00")).take

      m.geographical_area_sid.should == 103
      m.measure_components.first.duty_amount.should == 1.7799
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end

    it "should create measures for CN" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        geographical_area: "CN",
                        validity_start_date: DateTime.parse("2005-01-01 11:00:00")).take
      m.geographical_area_sid.should == 439
      m.measure_components.first.duty_amount.should == 2.300
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end

    it "should create measures for IN" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        geographical_area: "IN",
                        validity_start_date: DateTime.parse("2005-01-01 11:00:00")).take
      m.geographical_area_sid.should == 154
      m.measure_components.first.duty_amount.should == 2.000
      m.measure_components.first.monetary_unit_code.should == 'GBP'
    end
  end

  context 'Daily Update TAME' do
    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-11-15 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "0101010100") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-01-01 00:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "0202020200") }
    let!(:mfcm3){ create(:mfcm, :with_goods_nomenclature, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-30 14:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", cmdty_code: "0303030300") }

    let!(:tame) { create(:tame, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-11-15 11:00:00"), msrgp_code: "VT", msr_type: "S", tty_code: "813", adval_rate: 15.000) }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before do
      ChiefTransformer.instance.invoke(:initial_load)
    end

    it "should create the 0101010100 measure" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100", validity_start_date: DateTime.parse("2007-11-15 11:00:00")).take
      m.measure_components.first.duty_amount.should == 15
    end
    it "should create the 0202020200 measure" do
      m = Measure.where(goods_nomenclature_item_id: "0202020200", validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
      m.measure_components.first.duty_amount.should == 15
    end
    it "should create the 0303030300 measure" do
      m = Measure.where(goods_nomenclature_item_id: "0303030300", validity_start_date: DateTime.parse("2008-04-30 14:00:00")).take
      m.measure_components.first.duty_amount.should == 15
    end

    context "TAME Daily Scenario 1: Changed VAT rate" do
      context "Alt 1. Update and Insert" do
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 15.000,
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00")) }
        let!(:tame2) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 17.000) }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 5
        end

        it 'should add end date to measure 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should add end date to measure 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should increase Duty Amount to 17% for measure 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0101010100 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0202020200 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end
      end

      # In alternative 2 and alternative 3 the Taric measure -3 just updates the existing measure component (43005) with the new rate since its Taric measure start date is after the received FEDATE.
      context "Alt 2. Update" do
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 17.000) }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 5
        end

        it 'should add end date to measure 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should add end date to measure 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should increase Duty Amount to 17% for measure 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0101010100 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0202020200 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end
      end

      context "Alt 3. Delete and Insert" do
        let!(:tame4) { create(:tame, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 15.000) }
        let!(:tame5) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 17.000) }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 5
        end

        it 'should add end date to measure 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should add end date to measure 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'should increase Duty Amount to 17% for measure 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0101010100 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

        it 'should create new Measure for 0202020200 with duty amount of 17%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17
        end

      end

      # New, changed and deleted national measures in Taric

      # From the above mentioned records the following national measures will exist after the CHIEF records have been handled, this is the case independent if the records are received as alternative 1 or alternative 2.
      # New records
      # Measure Sid Start Date  End Date  Commodity Duty Amount
      #   -1  2007-11-16  2008-03-31  0101010100  15%
      #   -2  2008-01-01  2008-03-31  0202020200  15%
      #   -3  2008-05-01    0303030300  17%
      # * -4  2008-04-01    0101010100  17%
      # * -5  2008-04-01    0202020200  17%
    end

    context "TAME Daily Scenario 2: VAT applied to another commodity code" do
      context "Alt 1. Update and Insert" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm5) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0404040400") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'creates commodity 0404040400' do
          m = Measure.where(goods_nomenclature_item_id: "0404040400",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end

      context "Alt 2. Delete and Insert" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm5) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0404040400") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'creates commodity 0404040400' do
          m = Measure.where(goods_nomenclature_item_id: "0404040400",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    context "TAME Daily Scenario 3: VAT no longer applied to commodity" do
      context "Alt 1. Update" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end

      context "Alt 2. Delete" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    context "TAME Daily Scenario 4: VAT applied to additional commodity" do
      context "Alt 1. Insert" do
        let!(:mfcm4) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0404040400") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates new measure for commodity 0404040400' do
          m = Measure.where(goods_nomenclature_item_id: "0404040400",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    context "TAME Daily Scenario 5: VAT applied to incorrect commodity" do
      context "Alt 1. Deletion" do
        let!(:mfcm4) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2007-11-15 11:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    context 'TAME Daily Scenario 6: VAT removed' do
      context "Alt 1. Update, Update and delete" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm5) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0202020200") }
        let!(:mfcm6) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-05-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0303030300") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'keeps three measures in the database' do
          Measure.count.should == 3
        end

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0202020100' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            validity_end_date: DateTime.parse("2008-05-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end

      context "Alt 2. Single Update" do
        # Won't happen according to the documentation
      end

      context "Alt 3. Single Deletetion" do
        # Won't happen according to the documentation
      end

      context "Alt 4. Three Deletions" do
        let!(:mfcm4) { create(:mfcm, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm5) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0202020200") }
        let!(:mfcm6) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-05-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0303030300") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'keeps three measures in the database' do
          Measure.count.should == 3
        end

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0202020100' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            validity_end_date: DateTime.parse("2008-05-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end

      context "Alt 5. One TAME deletion and Three MFCM Deletions" do
        let!(:tame2) { create(:tame, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 15.000) }
        let!(:mfcm4) { create(:mfcm, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm5) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0202020200") }
        let!(:mfcm6) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-05-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0303030300") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'keeps three measures in the database' do
          Measure.count.should == 3
        end

        it 'adds validity end date to commodity 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0202020100' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'adds validity end date to commodity 0303030300' do
          pending("Check if example is valid.")
          # m = Measure.where(goods_nomenclature_item_id: "0303030300",
          #                   validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
          #                   validity_end_date: DateTime.parse("2008-05-01 00:00:00")).take
          # m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    context 'TAME Daily Scenario 7: Incorrect VAT rate' do
      context "Alt 1. Update" do
        let!(:tame2) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     adval_rate: 17.00) }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'updates duty amount for commodity 0101010100 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00")).take
          m.measure_components.first.duty_amount.should == 17.0
        end

        it 'updates duty amount for commodity 0202020200 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 17.0
        end

        it 'updates duty amount for commodity 0303030300 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00")).take
          m.measure_components.first.duty_amount.should == 17.0
        end
      end
    end
  end

  context "Daily Update TAMF" do
    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "411",
                                cmdty_code: "0101010100") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "411",
                                cmdty_code: "0202020200") }
    let!(:mfcm3){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2008-04-30 14:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "411",
                                cmdty_code: "0303030300") }
    let!(:mfcm4){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "570",
                                cmdty_code: "0101010100") }
    let!(:mfcm5){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "570",
                                cmdty_code: "0202020200") }
    let!(:mfcm6){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2008-04-30 14:00:00"),
                                msrgp_code: "EX",
                                msr_type: "EXF",
                                tty_code: "570",
                                cmdty_code: "0303030300") }
    let!(:tamf1) { create(:tamf, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411",
                                 spfc1_rate: 20.0,
                                 spfc2_rate: 1)}
    let!(:tamf2) { create(:tamf, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "570",
                                 spfc1_rate: 10.0)}

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before do
      ChiefTransformer.instance.invoke(:initial_load)
    end

    it 'creates measure for 0101010100 with two measure components for duty amount of 20% and max 1kg' do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                        measure_type: 'DAA').take
      m.measure_components.first.duty_amount.should == 20
      m.measure_components.last.duty_amount.should == 1
    end

    it 'creates measure for 0202020200 with two measure components for duty amount of 20% and max 1kg' do
      m = Measure.where(goods_nomenclature_item_id: "0202020200",
                        validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                        measure_type: 'DAA').take
      m.measure_components.first.duty_amount.should == 20
      m.measure_components.last.duty_amount.should == 1
    end

    it 'creates measure for 0303030300 with two measure components for duty amount of 20% and max 1kg' do
      m = Measure.where(goods_nomenclature_item_id: "0303030300",
                        validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                        measure_type: 'DAA').take
      m.measure_components.first.duty_amount.should == 20
      m.measure_components.last.duty_amount.should == 1
    end

    it 'create measure for 0101010100 with one measure component, duty amount of 10%' do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                        measure_type: 'EGJ').take
      m.measure_components.first.duty_amount.should == 10
    end

    it 'create measure for 0202020200 with one measure component, duty amount of 10%' do
      m = Measure.where(goods_nomenclature_item_id: "0202020200",
                        validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                        measure_type: 'EGJ').take
      m.measure_components.first.duty_amount.should == 10
    end

    it 'create measure for 0303030300 with one measure component, duty amount of 10%' do
      m = Measure.where(goods_nomenclature_item_id: "0303030300",
                        validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                        measure_type: 'EGJ').take
      m.measure_components.first.duty_amount.should == 10
    end

    describe "TAMF Daily Scenario 1: Added max amount" do
      describe "Alt 1. Update and Insert" do
        let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0)}
        let!(:tamf4) { create(:tamf, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0,
                                     spfc2_rate: 2)}
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570") }
        let!(:tame2) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds two new measures' do
          Measure.count.should == 8
        end

        it 'adds end date to measure for 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds end date to measure for 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds additional measure component to 0303030300', :focus do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'EGJ').take
          binding.pry
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0101010100 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0202020200 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end
      end

      describe "Alt 2. Update" do
        let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0,
                                     spfc2_rate: 2)}
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds two new measures' do
          Measure.count.should == 8
        end

        it 'adds end date to measure for 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds end date to measure for 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds additional measure component to 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0101010100 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0202020200 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end
      end

      describe "Alt 3. Update" do
        let!(:tamf3) { create(:tamf, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0) }
        let!(:tamf4) { create(:tamf, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0,
                                     spfc2_rate: 2) }
        let!(:tame1) { create(:tame, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570") }
        let!(:tame2) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'adds two new measures' do
          Measure.count.should == 8
        end

        it 'adds end date to measure for 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds end date to measure for 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 10
        end

        it 'adds additional measure component to 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0101010100 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'creates new measure  for 0202020200 with measure components for duty amount 10% and 2kg' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end
      end
    end

    describe "TAMF Daily Scenario 2: Added max amount" do
      describe "Alt 1. Update" do
        let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "570",
                                     spfc1_rate: 10.0,
                                     spfc2_rate: 2.0)}

        before {
          ChiefTransformer.instance.invoke
        }

        it 'does not add new measures' do
          Measure.count.should == 6
        end

        it 'adds additional duty amount of 2kg to 0101010100' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'adds additional duty amount of 2kg to 0202020200' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end

        it 'adds additional duty amount of 2kg to 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'EGJ').take
          m.measure_components.first.duty_amount.should == 10
          m.measure_components.last.duty_amount.should == 2
        end
      end
    end

    describe "TAMF Daily Scenario 3: Removed max amount" do
      describe "Alt 1. Update and Insert" do
        let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411",
                                     spfc1_rate: 20.0,
                                     spfc2_rate: 1.0)}
        let!(:tamf4) { create(:tamf, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411",
                                     spfc1_rate: 20.0)}
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411") }
        let!(:tame2) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 8
        end

        it 'adds validity end date to 0101010100 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'adds validity end date to 0202020200 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'removes measure component (1kg) from 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.size.should == 1
        end

        it 'creates new measure for 0101010100 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end

        it 'creates new measure for 0202020200 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end
      end

      describe "Alt 2. Update" do
        let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411",
                                     spfc1_rate: 20.0) }
        let!(:tame1) { create(:tame, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 8
        end

        it 'adds validity end date to 0101010100 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'adds validity end date to 0202020200 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'removes measure component (1kg) from 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.size.should == 1
        end

        it 'creates new measure for 0101010100 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end

        it 'creates new measure for 0202020200 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end
      end

      describe "Alt 3. Delete and Insert" do
        let!(:tamf3) { create(:tamf, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411",
                                     spfc1_rate: 20.0,
                                     spfc2_rate: 1) }
        let!(:tamf4) { create(:tamf, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411",
                                     spfc1_rate: 20.0) }
        let!(:tame1) { create(:tame, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411") }
        let!(:tame2) { create(:tame, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                     msrgp_code: "EX",
                                     msr_type: "EXF",
                                     tty_code: "411") }

        before {
          ChiefTransformer.instance.invoke
        }

        it 'creates two new measures' do
          Measure.count.should == 8
        end

        it 'adds validity end date to 0101010100 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'adds validity end date to 0202020200 measure' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
                            validity_end_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.last.duty_amount.should == 1
        end

        it 'removes measure component (1kg) from 0303030300' do
          m = Measure.where(goods_nomenclature_item_id: "0303030300",
                            validity_start_date: DateTime.parse("2008-04-30 14:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
          m.measure_components.size.should == 1
        end

        it 'creates new measure for 0101010100 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end

        it 'creates new measure for 0202020200 with duty amount of 20%' do
          m = Measure.where(goods_nomenclature_item_id: "0202020200",
                            validity_start_date: DateTime.parse("2008-04-01 00:00:00"),
                            measure_type: 'DAA').take
          m.measure_components.first.duty_amount.should == 20
        end
      end
    end
  end

  context "Daily Update MFCM" do
    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature,
                                amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                msrgp_code: "VT",
                                msr_type: "S",
                                tty_code: "813",
                                cmdty_code: "0101010100") }

    let!(:tame) { create(:tame, amend_indicator: "I",
                                fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                msrgp_code: "VT",
                                msr_type: "S",
                                tty_code: "813",
                                adval_rate: 15.000) }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before do
      ChiefTransformer.instance.invoke(:initial_load)
    end

    it "should create the 0101010100 measure" do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        validity_start_date: DateTime.parse("2007-11-15 11:00:00")).take
      m.measure_components.first.duty_amount.should == 15
    end

    describe "MFCM Daily Scenario 1: Updated measure with later start date" do

      describe "Alt 1. Update" do
        let!(:mfcm2){ create(:mfcm, amend_indicator: "U",
                                    fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                    msrgp_code: "VT",
                                    msr_type: "S",
                                    tty_code: "813",
                                    cmdty_code: "0101010100") }

        before(:each) { ChiefTransformer.instance.invoke }

        it 'no changes should be done to Measure because just fe_tsmp was moved forward' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    describe "MFCM Daily Scenario 2: Updated measure with later start date" do
      describe 'Alt 1: Update and Insert' do
        let!(:mfcm2){ create(:mfcm, amend_indicator: "U",
                                    fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                    le_tsmp: DateTime.parse("2007-12-31 11:00:00"),
                                    msrgp_code: "VT",
                                    msr_type: "S",
                                    tty_code: "813",
                                    cmdty_code: "0101010100") }
        let!(:mfcm3){ create(:mfcm, amend_indicator: "I",
                                    fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                    msrgp_code: "VT",
                                    msr_type: "S",
                                    tty_code: "813",
                                    cmdty_code: "0101010100") }

        before(:each) { ChiefTransformer.instance.invoke }

        it 'leaves two measures in the table' do
          Measure.count.should == 2
        end

        it 'adds end date to existing measure' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2007-12-31 11:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end

        it 'creates new measure with new start date' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end

    describe "MFCM Daily Scenario 3: Updated measure with later start date for terminated measure" do
      describe 'Alt 1: Update' do
        let!(:mfcm1) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2007-11-30 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm2) { create(:mfcm, amend_indicator: "U",
                                     fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before(:each) { ChiefTransformer.instance.invoke }

        it 'adds end date to existing measure' do
          m1 = Measure.where(goods_nomenclature_item_id: "0101010100",
                             validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                             validity_end_date: DateTime.parse("2007-11-30 00:00:00")).take
          m1.measure_components.first.duty_amount.should == 15
        end

        it 'creates new measure with new start date' do
          m2 = Measure.where(goods_nomenclature_item_id: "0101010100",
                             validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m2.measure_components.first.duty_amount.should == 15
        end
      end

      describe 'Alt 2: Insert' do
        let!(:mfcm1) { create(:mfcm, :with_goods_nomenclature,
                                     amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     le_tsmp: DateTime.parse("2007-11-30 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm2) { create(:mfcm, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before(:each) { ChiefTransformer.instance.invoke }

        it 'adds end date to existing measure' do
          m1 = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                            validity_end_date: DateTime.parse("2007-11-30 00:00:00")).take
          m1.measure_components.first.duty_amount.should == 15
        end

        it 'creates new measure with new start date' do
          m2 = Measure.where(goods_nomenclature_item_id: "0101010100",
                             validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m2.measure_components.first.duty_amount.should == 15
        end
      end
    end

    describe "MFCM Daily Scenario 4: Start date for measure moved forward" do
      describe 'Alt 1: Deletion and Insertion' do
        let!(:mfcm2) { create(:mfcm, amend_indicator: "X",
                                     fe_tsmp: DateTime.parse("2007-11-15 11:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }
        let!(:mfcm3) { create(:mfcm, amend_indicator: "I",
                                     fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                     msrgp_code: "VT",
                                     msr_type: "S",
                                     tty_code: "813",
                                     cmdty_code: "0101010100") }

        before(:each) { ChiefTransformer.instance.invoke }

        it 'deletes existing Matching measures' do
          Measure.where(goods_nomenclature_item_id: "0101010100",
                        validity_start_date: DateTime.parse("2007-11-15 11:00:00"),
                        validity_end_date: DateTime.parse("2007-11-15 11:00:00")).take
        end

        it 'inserts new measures' do
          m = Measure.where(goods_nomenclature_item_id: "0101010100",
                            validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
          m.measure_components.first.duty_amount.should == 15
        end
      end
    end
  end

  context "Unsupported Scenario 1: Several updates in same daily update file" do
    let!(:mfcm1) { create(:mfcm, :with_goods_nomenclature,
                                 amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411",
                                 cmdty_code: "0101010100") }
    let!(:tame1) { create(:tame, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411") }
    let!(:tamf1) { create(:tamf, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411",
                                 adval1_rate: 20.0) }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before { ChiefTransformer.instance.invoke(:initial_load) }

    it 'creates one measure' do
      Measure.count.should == 1
    end

    it 'measure for 0101010100 with duty rate of 20.0' do
      m = Measure.where(goods_nomenclature_item_id: "0101010100",
                        validity_start_date: DateTime.parse("2008-01-01 00:00:00")).take
      m.measure_components.first.duty_amount.should == 20
    end

    describe "Alt 1. Multiple updates" do
      let!(:tame2) { create(:tame, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-02-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411") }
      let!(:tame3) { create(:tame, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411") }
      let!(:tamf2) { create(:tamf, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-02-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   adval1_rate: 19.0) }
      let!(:tamf3) { create(:tamf, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-04-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   adval1_rate: 18.0) }

      before { ChiefTransformer.instance.invoke }

      # it 'creates two new measures' do
      #   Measure.count.should == 3
      # end

      # TODO fix
      # it 'adds end date to 0101010100 with duty amount of 20%' do
      #   m = Measure.where(goods_nomenclature_item_id: "0101010100",
      #                     validity_start_date: DateTime.parse("2008-01-01 00:00:00"),
      #                     validity_end_date: DateTime.parse("2008-02-01 00:00:00")).take
      #   m.measure_components.first.duty_amount.should == 20
      # end

      # it 'creates new temporary measure for 0101010100 with duty amount of 20%' do
      #   m = Measure.where(goods_nomenclature_item_id: "0101010100",
      #                     validity_start_date: DateTime.parse("2008-02-01 00:00:00"),
      #                     validity_end_date: DateTime.parse("2008-04-01 00:00:00")).take
      #   m.measure_components.first.duty_amount.should == 19
      # end

      it 'creates new measure for 0101010100 with duty amount of 18' do
        m = Measure.where(goods_nomenclature_item_id: "0101010100",
                          validity_start_date: DateTime.parse("2008-04-01 00:00:00")).take
        m.measure_components.first.duty_amount.should == 18
      end
    end
  end

  context "Unsupported Scenario 2: Insert and delete in same daily update file" do
    let!(:tame1) { create(:tame, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2007-01-01 00:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411") }
    let!(:tamf1) { create(:tamf, amend_indicator: "I",
                                 fe_tsmp: DateTime.parse("2007-01-01 00:00:00"),
                                 msrgp_code: "EX",
                                 msr_type: "EXF",
                                 tty_code: "411",
                                 adval1_rate: 20.0) }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

    before { ChiefTransformer.instance.invoke(:initial_load) }

    it 'no Taric measures should be created' do
      Measure.count.should == 0
    end

    context 'Alt 1. Insertion and deletion' do
      let!(:mfcm1) { create(:mfcm, amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   cmdty_code: "0101010100") }
      let!(:mfcm2) { create(:mfcm, amend_indicator: "X",
                                   fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   cmdty_code: "0101010100") }

      before { ChiefTransformer.instance.invoke }

      it 'no Taric measures should be created' do
        Measure.count.should == 0
      end
    end
  end

  context "Unsupported Scenario 3: Insert and update in same daily file" do
    describe "Alt 1. Insert and Update" do
      let!(:mfcm1) { create(:mfcm, :with_goods_nomenclature,
                                   amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   cmdty_code: "0101010100") }
      let!(:tame1) { create(:tame, amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411") }
      let!(:tame2) { create(:tame, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411") }
      let!(:tamf1) { create(:tamf, amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   adval1_rate: 20.0) }
      let!(:tamf2) { create(:tamf, amend_indicator: "U",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   adval1_rate: 15.0) }

      let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

      before { ChiefTransformer.instance.invoke }

      it 'creates measure for 0101010100 with duty rate of 15%' do
        Measure.count.should == 1
        m = Measure.where({validity_start_date: DateTime.parse("2008-03-01 00:00:00"),
                           goods_nomenclature_item_id: "0101010100"}).take
        m.measure_components.first.duty_amount.should == 15
      end
    end

    describe "Alt 2. Insert" do
      let!(:mfcm1) { create(:mfcm, :with_goods_nomenclature,
                                   amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-01-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   cmdty_code: "0101010100") }
      let!(:tame1) { create(:tame, amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411") }
      let!(:tamf2) { create(:tamf, amend_indicator: "I",
                                   fe_tsmp: DateTime.parse("2008-03-01 00:00:00"),
                                   msrgp_code: "EX",
                                   msr_type: "EXF",
                                   tty_code: "411",
                                   adval1_rate: 15.0) }

      let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes }

      before { ChiefTransformer.instance.invoke }

      it 'creates measure for 0101010100 with duty rate of 15%' do
        Measure.count.should == 1
        m = Measure.where({validity_start_date: DateTime.parse("2008-03-01 00:00:00"),
                           goods_nomenclature_item_id: "0101010100"}).take
        m.measure_components.first.duty_amount.should == 15
      end
    end
  end
end
