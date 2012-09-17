require 'spec_helper'
require 'chief_transformer'

describe "CHIEF: Prohibitions and Restrictions" do
  before(:all) { preload_standing_data }
  after(:all)  { clear_standing_data }

  context "Initial Load Scenario P&R" do
    # In this scenario a number of P&R measures are created. The created measures represent Export and Import restrictions for:
    # * specific countries or regions (IQ, XC)
    # * a country group that is translated to an EU country group (D066)
    # * a national country group that has been created in the TARIC database (A001)

    let!(:a001) { create(:geographical_area, geographical_area_id: "A001", geographical_area_sid: -1, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:iq) { create(:geographical_area, geographical_area_id: "IQ", geographical_area_sid: -2, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:xc) { create(:geographical_area, geographical_area_id: "XC", geographical_area_sid: -3, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }

    # excluded countries for D066 AD,FO,NO,SM,IS
    let!(:ad) { create(:geographical_area, geographical_area_id: "AD", geographical_area_sid: 140, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:fo) { create(:geographical_area, geographical_area_id: "FO", geographical_area_sid: 330, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:no) { create(:geographical_area, geographical_area_id: "NO", geographical_area_sid: 252, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }
    let!(:sm) { create(:geographical_area, geographical_area_id: "IT", geographical_area_sid: 382, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) } # IT not SM because Chief maps SM to IT check Chief::CountryCode
    let!(:is) { create(:geographical_area, geographical_area_id: "IS", geographical_area_sid: 53, validity_start_date: DateTime.parse("1975-07-18 00:00:00")) }

    let!(:tame1) { create(:tame, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-07-24 08:45:00"), msrgp_code: "HO", msr_type: "CON", tar_msr_no: "12113000") }
    let!(:tame2) { create(:tame, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "ATT", tar_msr_no: "1210100010") }
    let!(:tame3) { create(:tame, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "CVD", tar_msr_no: "2106909829") }
    let!(:tame4) { create(:tame, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "QRC", tar_msr_no: "97060000") }

    let!(:tamf1) { create(:tamf, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-07-24 08:45:00"), msrgp_code: "HO", msr_type: "CON", tar_msr_no: "12113000", cntry_orig: "IQ") }
    let!(:tamf2) { create(:tamf, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "ATT", tar_msr_no: "1210100010", cntry_disp: "XC") }
    let!(:tamf3) { create(:tamf, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "CVD", tar_msr_no: "2106909829", cngp_code: "D066") }
    let!(:tamf4) { create(:tamf, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "QRC", tar_msr_no: "97060000", cngp_code: "A001") }

    let!(:mfcm1){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2006-07-24 08:45:00"), msrgp_code: "HO", msr_type: "CON", tar_msr_no: "12113000", cmdty_code: "1211300000") }
    let!(:mfcm2){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2007-10-01 00:00:00"), msrgp_code: "PR", msr_type: "ATT", tar_msr_no: "1210100010", cmdty_code: "1210100010") }
    let!(:mfcm3){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "CVD", tar_msr_no: "2106909829", cmdty_code: "2106909829") }
    let!(:mfcm4){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "QRC", tar_msr_no: "97060000", cmdty_code: "9706000000") }
    let!(:mfcm5){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "QRC", tar_msr_no: "97060000", cmdty_code: "9706000010") }
    let!(:mfcm6){ create(:mfcm, :with_goods_nomenclature, :prohibition, amend_indicator: "I", fe_tsmp: DateTime.parse("2008-04-01 00:00:00"), msrgp_code: "PR", msr_type: "QRC", tar_msr_no: "97060000", cmdty_code: "9706000090") }

    let!(:geographical_area) { create :geographical_area, :fifteen_years, :erga_omnes, geographical_area_sid: 400 }

    before do
      ChiefTransformer.instance.invoke
    end

    it "should create measure for 1211300000" do
      m = Measure.where(goods_nomenclature_item_id: "1211300000", validity_start_date: DateTime.parse("2006-07-24 08:45:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "IQ"
    end

    it "should create measure for 1210100010" do
      m = Measure.where(goods_nomenclature_item_id: "1210100010", validity_start_date: DateTime.parse("2008-04-01 00:00:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "XC"
    end

    it "should create measure for 2106909829" do
      m = Measure.where(goods_nomenclature_item_id: "2106909829", validity_start_date: DateTime.parse("2008-04-01 00:00:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "1011"
    end

    it "should create measure for 9706000000" do
      m = Measure.where(goods_nomenclature_item_id: "9706000000", validity_start_date: DateTime.parse("2008-04-01 00:00:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "A001"
    end

    it "should create measure for 9706000010" do
      m = Measure.where(goods_nomenclature_item_id: "9706000010", validity_start_date: DateTime.parse("2008-04-01 00:00:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "A001"
    end

    it "should create measure for 9706000090" do
      m = Measure.where(goods_nomenclature_item_id: "9706000090", validity_start_date: DateTime.parse("2008-04-01 00:00:00")).first
      m.should_not be_nil
      m[:geographical_area].should == "A001"
    end

    it "should create measure conditions for 1211300000" do
      MeasureCondition.where(measure_sid: -1).count.should == 3
      m = MeasureCondition.where(measure_sid: -1).first
      m.condition_code.should == "Z"
      m.certificate_code.should == "113"
    end

    it "should create measure conditions for 1210100010" do
      MeasureCondition.where(measure_sid: -2).count.should == 3
      m = MeasureCondition.where(measure_sid: -2).first
      m.condition_code.should == "Z"
      m.certificate_code.should == "001"
    end

    it "should create measure conditions for 2106909829" do
      MeasureCondition.where(measure_sid: -3).count.should == 2
      m = MeasureCondition.where(measure_sid: -3).first
      m.condition_code.should == "B"
      m.certificate_code.should == "853"
    end

    it "should create measure conditions for 9706000000" do
      MeasureCondition.where(measure_sid: -4).count.should == 2
      m = MeasureCondition.where(measure_sid: -4).first
      m.condition_code.should == "B"
      m.certificate_code.should == "115"
    end
    it "should create measure conditions for 9706000010" do
      MeasureCondition.where(measure_sid: -5).count.should == 2
      m = MeasureCondition.where(measure_sid: -5).first
      m.condition_code.should == "B"
      m.certificate_code.should == "115"
    end
    it "should create measure conditions for 9706000090" do
      MeasureCondition.where(measure_sid: -6).count.should == 2
      m = MeasureCondition.where(measure_sid: -6).first
      m.condition_code.should == "B"
      m.certificate_code.should == "115"
    end

    it "should create the following excluded countries or regions" do
      MeasureExcludedGeographicalArea.all.count.should == 5
    end

    # NOTE: spec is wrong, measure type CON does not have any footnotes.
    # it "should create the following footnote association for 015" do
    #   f = FootnoteAssociationMeasure.where(measure_sid: -1, footnote_type_id: "04", footnote_id: "015").first
    #   f.should_not be_nil
    #   f.national.should be_true
    # end

    it "should create the following footnote association for 004" do
      f = FootnoteAssociationMeasure.where(measure_sid: -2, footnote_type_id: "04", footnote_id: "004").first
      f.should_not be_nil
      f.national.should be_true
    end

    it "should create the following footnote association for 006" do
      f = FootnoteAssociationMeasure.where(measure_sid: -3, footnote_type_id: "04", footnote_id: "006").first
      f.should_not be_nil
      f.national.should be_true
    end

    it "should create the following footnote association for 011" do
      f = FootnoteAssociationMeasure.where(measure_sid: -4, footnote_type_id: "04", footnote_id: "011").first
      f.should_not be_nil
      f.national.should be_true
    end

    it "should create the following footnote association for 011#2" do
      f = FootnoteAssociationMeasure.where(measure_sid: -5, footnote_type_id: "04", footnote_id: "011").first
      f.should_not be_nil
      f.national.should be_true
    end

    it "should create the following footnote association for 011#3" do
      f = FootnoteAssociationMeasure.where(measure_sid: -6, footnote_type_id: "04", footnote_id: "011").first
      f.should_not be_nil
      f.national.should be_true
    end
  end
end
