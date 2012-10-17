require 'chief_transformer'
require 'tariff_synchronizer'

FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :goods_nomenclature do
    ignore do
      indents { 1 }
      description { Forgery(:basic).text }
    end

    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    producline_suffix   { [10,20,80].sample }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

    trait :fifteen_years do
      validity_start_date { Date.today.ago(15.years) }
    end

    trait :declarable do
      producline_suffix 80
    end

    trait :expired do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { Date.today.ago(1.year)  }
    end

    trait :with_indent do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_indent, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                       number_indents: evaluator.indents)
      }
    end

    trait :with_description do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_description, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                            validity_start_date: gono.validity_start_date,
                                                            validity_end_date: gono.validity_end_date,
                                                            description: evaluator.description)
      }
    end
  end

  factory :commodity, parent: :goods_nomenclature, class: Commodity do
    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      producline_suffix { 10 }
    end
  end

  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }

    trait :with_section do
      after(:create) { |chapter, evaluator|
        FactoryGirl.create(:section)
      }
    end

    trait :with_note do
      after(:create) { |chapter, evaluator|
        FactoryGirl.create(:chapter_note, chapter_id: chapter.goods_nomenclature_sid)
      }
    end
  end

  factory :heading, parent: :goods_nomenclature, class: Heading do
    # +1 is needed to avoid creating heading with gono id in form of
    # xx00xxxxxx which is a Chapter
    goods_nomenclature_item_id { "#{4.times.map{ Random.rand(8)+1 }.join}000000" }

    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_grouping do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map{ Random.rand(9) }.join}")
      }
    end

    trait :with_chapter do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: heading.chapter_id)
      }
    end
  end

  factory :export_refund_nomenclature do
    ignore do
      indents { 1 }
    end

    export_refund_nomenclature_sid { generate(:sid) }
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    export_refund_code   { 3.times.map{ Random.rand(9) }.join }
    additional_code_type { Random.rand(9) }
    productline_suffix   { [10,20,80].sample }
    validity_start_date  { Date.today.ago(2.years) }
    validity_end_date    { nil }

    trait :with_indent do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:export_refund_nomenclature_indent, export_refund_nomenclature_sid: gono.export_refund_nomenclature_sid,
                                                               number_export_refund_nomenclature_indents: evaluator.indents)
      }
    end
  end

  factory :export_refund_nomenclature_indent do
    export_refund_nomenclature_sid { generate(:sid) }
    export_refund_nomenclature_indents_sid { generate(:sid) }
    number_export_refund_nomenclature_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_indent do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_indent_sid { generate(:sid) }
    number_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description_period do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_description_period_sid { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description do
    ignore do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date { nil }
    end

    goods_nomenclature_sid { generate(:sid) }
    description { Forgery(:basic).text }
    goods_nomenclature_description_period_sid { generate(:sid) }

    after(:create) { |gono_desc, evaluator|
      FactoryGirl.create(:goods_nomenclature_description_period, goods_nomenclature_sid: gono_desc.goods_nomenclature_sid,
                                                                 goods_nomenclature_description_period_sid: gono_desc.goods_nomenclature_description_period_sid,
                                                                 validity_start_date: evaluator.validity_start_date,
                                                                 validity_end_date: evaluator.validity_end_date
                                                                 )
    }
  end

  factory :geographical_area do
    geographical_area_sid { generate(:sid) }
    geographical_area_id { Forgery(:basic).text(exactly: 2) }
    geographical_code { Forgery(:basic).text(exactly: 2) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :fifteen_years do
      validity_start_date { Date.today.ago(15.years) }
    end

    trait :erga_omnes do
      geographical_area_id { "1011" }
    end
  end

  factory :quota_definition do
    quota_definition_sid   { generate(:sid) }
    quota_order_number_sid { generate(:sid) }
    quota_order_number_id  { 6.times.map{ Random.rand(9) }.join }
    critical_state         { 'N' }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end
  end

  factory :quota_balance_event do
    quota_definition
    last_import_date_in_allocation { Time.now }
    old_balance { Forgery(:basic).number }
    new_balance { Forgery(:basic).number }
    imported_amount { Forgery(:basic).number }
    occurrence_timestamp { Time.now }
  end

  factory :quota_exhaustion_event do
    quota_definition
    exhaustion_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :quota_critical_event do
    quota_definition
    critical_state_change_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :section do
    position { Forgery(:basic).number }
    numeral { ["I", "II", "III"].sample }
    title { Forgery(:lorem_ipsum).sentence }
  end

  factory :measure do
    measure_sid  { generate(:sid) }
    measure_type_id { generate(:sid) }
    measure_generating_regulation_id { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_measure_type do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:measure_type, measure_type_id: measure.measure_type_id)
      }
    end

    trait :with_base_regulation do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:base_regulation, base_regulation_id: measure.measure_generating_regulation_id)
      }
    end
  end

  factory :measure_type do
    measure_type_id     { Forgery(:basic).text(exactly: 3) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :export do
      trade_movement_code { 1 }
    end

    trait :import do
      trade_movement_code { 0 }
    end
  end

  factory :base_regulation do
    base_regulation_id { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :search_reference do
    title { Forgery(:basic).text }
    reference { Forgery(:basic).text }
  end

  factory :mfcm, class: Chief::Mfcm do
    amend_indicator { ["I", "U", "X"].sample }
    fe_tsmp { DateTime.now.ago(10.years) }
    msrgp_code { ChiefTransformer::CandidateMeasure::RESTRICTION_GROUP_CODES.sample }
    msr_type { (ChiefTransformer::CandidateMeasure::NATIONAL_MEASURE_TYPES - ['VTA','VTE', 'VTS', 'VTZ', 'EXA', 'EXB', 'EXC', 'EXD']).sample}
    tty_code { Forgery(:basic).text(exactly: 3) }
    le_tsmp  { nil }
    audit_tsmp { nil }
    cmdty_code { 10.times.map{ Random.rand(9) }.join }

    ignore do
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
        FactoryGirl.create(:tame, msrgp_code: mfcm.msrgp_code,
                                  msr_type: mfcm.msr_type,
                                  tty_code: mfcm.tty_code,
                                  fe_tsmp: mfcm.fe_tsmp,
                                  adval_rate: 20)
        FactoryGirl.create(:measure_type_adco, measure_group_code: "EX",
                                               measure_type: "EXF",
                                               tax_type_code: "591",
                                               measure_type_id: "",
                                               adtnl_cd_type_id: 'EIA')
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
                                               adtnl_cd_type_id: 'EIA')
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

  factory :chief_update, class: TariffSynchronizer::ChiefUpdate do
    ignore do
      example_date { Forgery(:date).date }
    end

    filename { TariffSynchronizer::ChiefUpdate.file_name_for(example_date)  }
    issue_date { example_date }
    update_type { 'TariffSynchronizer::ChiefUpdate' }
    state { 'P' }
    file {
      %Q{
        "AAAAAAAAAAA","01/01/1900:00:00:00"," ","20120312",
        "TAME       ","01/03/2012:00:00:00","U","PR","TFC",null,"03038931",null,null,null,null,"20/02/2012:09:34:00",null,null,"Y",null,"N",null,null,null,null,null,null,"Y",null,"N",null,null,null,"ITP BATCH INTERFACE",null,null,null,null,null,null,"N",
        "TAME       ","01/03/2012:00:00:00","U","DS","G","A10","16052190 45",null,null,null,null,"20/02/2012:09:40:00",null,null,"N",null,"N",null,null,null,null,null,null,"N",null,"N",null,null,null,"ITP BATCH INTERFACE",null,null,null,null,null,null,"N",
        "ZZZZZZZZZZZ","31/12/9999:23:59:59"," ",434,
      }
    }

    trait :applied do
      state { 'A' }
    end
  end

  factory :taric_update, class: TariffSynchronizer::TaricUpdate do
    ignore do
      example_date { Forgery(:date).date }
    end

    filename { TariffSynchronizer::TaricUpdate.file_name_for(example_date)  }
    issue_date { example_date }
    update_type { 'TariffSynchronizer::TaricUpdate' }
    state { 'P' }
    file {
     %Q{
      <?xml version="1.0" encoding="UTF-8"?>
      <env:envelope xmlns="urn:publicid:-:DGTAXUD:TARIC:MESSAGE:1.0" xmlns:env="urn:publicid:-:DGTAXUD:GENERAL:ENVELOPE:1.0" id="1">
        <env:transaction id="1">
          <app.message id="8">
            <transmission>
              <record>
                <transaction.id>2179611</transaction.id>
                <record.code>200</record.code>
                <subrecord.code>00</subrecord.code>
                <record.sequence.number>388</record.sequence.number>
                <update.type>3</update.type>
                <footnote>
                  <footnote.type.id>TM</footnote.type.id>
                  <footnote.id>127</footnote.id>
                  <validity.start.date>1972-01-01</validity.start.date>
                  <validity.end.date>1995-12-31</validity.end.date>
                </footnote>
              </record>
            </transmission>
          </app.message>
        </env:transaction>
      </env:envelope>
      }
    }

    trait :applied do
      state { 'A' }
    end
  end
end
