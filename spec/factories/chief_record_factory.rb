FactoryGirl.define do
  factory :mfcm, class: Chief::Mfcm do
    amend_indicator { ["I", "U", "X"].sample }
    fe_tsmp { DateTime.now.ago(10.years) }
    msrgp_code { ChiefTransformer::CandidateMeasure::RESTRICTION_GROUP_CODES.sample }
    msr_type { (ChiefTransformer::CandidateMeasure::NATIONAL_MEASURE_TYPES - ['VTA','VTE', 'VTS', 'VTZ', 'EXA', 'EXB', 'EXC', 'EXD']).sample}
    tty_code { Forgery(:basic).text(exactly: 3) }
    le_tsmp  { nil }
    audit_tsmp { nil }
    cmdty_code { 10.times.map{ Random.rand(9) }.join }

    transient do
      measure_type_id { ChiefTransformer::CandidateMeasure::NATIONAL_MEASURE_TYPES.sample }
    end

    before(:create) { |mfcm, evaluator|
      FactoryGirl.create(:measure_type_adco, measure_group_code: mfcm.msrgp_code,
                                             measure_type: mfcm.msr_type,
                                             tax_type_code: mfcm.tty_code,
                                             measure_type_id: evaluator.measure_type_id)
    }

    trait :for_insert do
      amend_indicator "I"
    end

    trait :prohibition do
      tty_code { nil }
    end

    trait :excise do
      msrgp_code { 'EX' }
      msr_type   { 'EXA' }
      tty_code   { 990 }
    end

    trait :with_vat_group do
      msrgp_code "VT"
      msr_type { ['A','E','S','Z'].sample }
    end

    trait :with_non_vat_group do
      msrgp_code "XX"
    end

    trait :with_geographical_area do
      after(:create) { |mfcm|
        FactoryGirl.create :geographical_area, :fifteen_years,
                           geographical_area_id: "1011"
      }
    end

    trait :with_goods_nomenclature do
      before(:create) { |mfcm|
        FactoryGirl.create :goods_nomenclature, :fifteen_years, :declarable,
                           :with_indent,
                           goods_nomenclature_item_id: mfcm.cmdty_code
      }
    end

    trait :unprocessed do
      processed { false }
    end

    trait :processed do
      processed { true }
    end

    trait :with_tame do
      after(:create) { |mfcm|
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tamf_conditions do
      with_tame # TAMF requires TAME to be present, it's a subsidiary entry
      msrgp_code "PR"
      msr_type "AHC"
      after(:create) { |mfcm|
        FactoryGirl.create(:tamf, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  amend_indicator: mfcm.amend_indicator)
        FactoryGirl.create(:measure_type_cond, measure_group_code: "PR",
                                               measure_type: "AHC",
                                               cond_cd: "B",
                                               comp_seq_no: "002",
                                               act_cd: '04')
      }
    end

    trait :with_tame_components do
      msrgp_code "EX"
      msr_type "EXF"
      tty_code "591"
      after(:create) { |mfcm|
        tame = FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                         msr_type: mfcm.msr_type,
                                         tty_code: mfcm.tty_code,
                                         fe_tsmp: mfcm.fe_tsmp,
                                         adval_rate: 20)
        FactoryGirl.create(:measure_type_adco, measure_group_code: "EX",
                                               measure_type: "EXF",
                                               tax_type_code: "591",
                                               measure_type_id: "",
                                               adtnl_cd_type_id: 'V')
         FactoryGirl.create(:chief_duty_expression, duty_expression_id_adval1: Forgery(:basic).number,
                                                    adval1_rate: tame.adval1_rate,
                                                    adval2_rate: tame.adval2_rate,
                                                    spfc1_rate: tame.spfc1_rate,
                                                    spfc2_rate: tame.spfc2_rate)
      }
    end

    trait :with_tamf_components do
      with_tame # TAMF requires TAME to be present, it's a subsidiary entry
      msrgp_code "EX"
      msr_type "EXF"
      tty_code "591"
      after(:create) { |mfcm|
        FactoryGirl.create(:tamf, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  adval1_rate: nil,
                                  adval2_rate: nil,
                                  spfc1_rate: 1,
                                  spfc2_rate: nil,
                                  amend_indicator: mfcm.amend_indicator)
        FactoryGirl.create(:measure_type_adco, measure_group_code: "EX",
                                               measure_type: "EXF",
                                               tax_type_code: "591",
                                               adtnl_cd_type_id: 'V')
      }
    end

    trait :with_tamf do
      after(:create) { |mfcm|
        FactoryGirl.create(:tamf, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tamf_start_date_after do
      after(:create) { |mfcm|
        FactoryGirl.create(:tamf, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp + 2.days)
      }
    end

    trait :with_tamf_start_date_before do
      after(:create) { |mfcm|
        FactoryGirl.create(:tamf, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp - 2.days,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tame_start_date_after do
      after(:create) { |mfcm|
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp + 2.days,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tame_start_date_before do
      after(:create) { |mfcm|
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp - 2.days,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tame_end_date_after do
      le_tsmp { DateTime.now.ago(8.years) }
      after(:create) { |mfcm|
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  le_tsmp: mfcm.le_tsmp + 2.days,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_tame_end_date_before do
      le_tsmp { DateTime.now.ago(8.years) }
      after(:create) { |mfcm|
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  le_tsmp: mfcm.le_tsmp - 2.days,
                                  amend_indicator: mfcm.amend_indicator)
      }
    end

    trait :with_le_tsmp do
      le_tsmp { DateTime.now.ago(8.years) }
    end

    trait :with_chief_measure_type_mapping do
      after(:create) { |mfcm, evaluator|
        FactoryGirl.create(:chief_measure_type_footnote, measure_type_id: evaluator.measure_type_id)
      }
    end
  end

  factory :tame, class: Chief::Tame do
    amend_indicator { ["I", "U", "X"].sample }
    fe_tsmp { DateTime.now.ago(10.years)  }
    msrgp_code { Forgery(:basic).text(exactly: 2) }
    msr_type { Forgery(:basic).text(exactly: 3) }
    tty_code { Forgery(:basic).text(exactly: 3) }
    adval_rate { nil }
    le_tsmp  { nil }
    audit_tsmp { nil }

    trait :prohibition do
      tty_code { nil }
    end

    trait :unprocessed do
      processed { false }
    end

    trait :processed do
      processed { true }
    end
  end

  factory :tamf, class: Chief::Tamf do
    amend_indicator { ["I", "U", "X"].sample }
    fe_tsmp { DateTime.now.ago(10.years)  }
    msrgp_code { Forgery(:basic).text(exactly: 2) }
    msr_type { Forgery(:basic).text(exactly: 3) }
    tty_code { Forgery(:basic).text(exactly: 3) }
    adval1_rate { nil }
    spfc1_rate { nil }

    trait :prohibition do
      tty_code { nil }
    end

    trait :unprocessed do
      processed { false }
    end

    trait :processed do
      processed { true }
    end
  end

  factory :measure_type_cond, class: Chief::MeasureTypeCond do
    measure_group_code { Forgery(:basic).text(exactly: 2) }
    measure_type       { Forgery(:basic).text(exactly: 3) }
    cond_cd            { nil }
    comp_seq_no        { nil }
    cert_type_cd       { nil }
    cert_ref_no        { nil }
    act_cd             { nil }
  end

  factory :measure_type_adco, class: Chief::MeasureTypeAdco do
    # measure_group_code { Forgery(:basic).text(exactly: 2) }
    # measure_type       { Forgery(:basic).text(exactly: 3) }
    # tax_type_code      { Forgery(:basic).text(exactly: 3) }
    # measure_type_id    { Forgery(:basic).text(exactly: 3) }
    adtnl_cd_type_id   { nil }
    adtnl_cd           { nil }
    zero_comp          { 1 }
  end

  factory :country_code, class: Chief::CountryCode do
    chief_country_cd { Forgery(:basic).text(exactly: 2).upcase }
    country_cd { Forgery(:basic).text(exactly: 2).upcase } # TARIC code
  end

  factory :country_group, class: Chief::CountryGroup do
    chief_country_grp { Forgery(:basic).text(exactly: 4).upcase }
    country_grp_region { Forgery(:basic).text(exactly: 4).upcase } # TARIC code

    trait :with_exclusions do
      country_exclusions { "#{Forgery(:basic).text(exactly: 2).upcase },#{Forgery(:basic).text(exactly: 2).upcase }" }
    end
  end

  factory :chief_duty_expression, class: Chief::DutyExpression do
    adval1_rate 0
    adval2_rate 0
    spfc1_rate 1
    spfc2_rate 0
    duty_expression_id_spfc1 "01"
    monetary_unit_code_spfc1 "GBP"
    duty_expression_id_spfc2 nil
    monetary_unit_code_spfc2 nil
    duty_expression_id_adval1 nil
    monetary_unit_code_adval1 nil
    duty_expression_id_adval2 nil
  end

  factory :chief_measurement_unit, class: Chief::MeasurementUnit do
    spfc_cmpd_uoq "098"
    spfc_uoq "078"
    measurem_unit_cd "ASX"
    measurem_unit_qual_cd "X"
  end

  factory :chief_measure_type_footnote, class: Chief::MeasureTypeFootnote do
    measure_type_id { Forgery(:basic).text(exactly: 3).upcase }
    footn_type_id { Forgery(:basic).text(exactly: 2).upcase }
    footn_id { Forgery(:basic).text(exactly: 3).upcase }
  end

  factory :base_update, class: TariffSynchronizer::BaseUpdate do
    transient do
      example_date { Forgery(:date).date }
    end

    filename { Forgery(:basic).text }
    issue_date { example_date }
    state { 'P' }

    trait :applied do
      state { 'A' }
    end

    trait :pending do
      state { 'P' }
    end

    trait :failed do
      state { 'F' }
    end

    trait :missing do
      state { 'M' }
    end
  end

  factory :chief_update, parent: :base_update, class: TariffSynchronizer::ChiefUpdate do
    filename { TariffSynchronizer::ChiefUpdate.file_name_for(example_date)  }
    update_type { 'TariffSynchronizer::ChiefUpdate' }
  end

  factory :taric_update, parent: :base_update, class: TariffSynchronizer::TaricUpdate do
    issue_date { example_date }
    filename { TariffSynchronizer::TaricUpdate.file_name_for(example_date, "TGB#{example_date.strftime("%y")}#{example_date.yday}.xml")  }
    update_type { 'TariffSynchronizer::TaricUpdate' }
  end

  factory :response, class: TariffSynchronizer::Response do
    url { Forgery::Internet.domain_name }
    response_code { [200, 404, 403].sample }
    content { Forgery(:basic).text }

    trait :success do
      response_code { 200 }
    end

    trait :not_found do
      response_code { 404 }
      content { nil }
    end

    trait :failed do
      response_code { 403 }
      content { nil }
    end

    trait :blank do
      success

      content { nil }
    end

    trait :retry_exceeded do
      failed

      after(:build) { |response| response.retry_count_exceeded! }
    end

    initialize_with {
      new(url, response_code, content)
    }
  end

  factory :comm, class: Chief::Comm do
    fe_tsmp { Date.today.ago(2.years) }
    le_tsmp { nil }
    cmdty_code    { 10.times.map{ Random.rand(9) }.join }
    uoq_code_cdu2 { 3.times.map{ Random.rand(9) }.join }
    uoq_code_cdu3 { 3.times.map{ Random.rand(9) }.join }
  end

  factory :tbl9, class: Chief::Tbl9 do
    txtlnno  { 1 }
    tbl_code { NationalMeasurementUnit.description_map.keys.sample }
    tbl_txt  {
      NationalMeasurementUnit.description_map.fetch(tbl_code) {
        Forgery(:basic).text # random if not found on map
      }
    }

    trait :unoq do
      tbl_type { 'UNOQ' }
    end
  end
end
