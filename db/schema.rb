Sequel.migration do
  change do
    create_table(:additional_code_description_periods) do
      column :additional_code_description_period_sid, "int(11)"
      column :additional_code_sid, "int(11)"
      column :additional_code_type_id, "varchar(1)"
      column :additional_code, "varchar(3)"
      column :validity_start_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:additional_code_type_id], :name=>:code_type_id
      index [:additional_code_description_period_sid], :name=>:description_period_sid
      index [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_descriptions) do
      column :additional_code_description_period_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :additional_code_sid, "int(11)"
      column :additional_code_type_id, "varchar(1)"
      column :additional_code, "varchar(3)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:language_id
      index [:additional_code_description_period_sid], :name=>:period_sid
      index [:additional_code_description_period_sid, :additional_code_type_id, :additional_code_sid], :name=>:primary_key, :unique=>true
      index [:additional_code_sid], :name=>:sid
      index [:additional_code_type_id], :name=>:type_id
    end

    create_table(:additional_code_type_descriptions) do
      column :additional_code_type_id, "varchar(1)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_additional_code_type_descriptions_on_language_id
      index [:additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_type_measure_types) do
      column :measure_type_id, "varchar(3)"
      column :additional_code_type_id, "varchar(1)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:measure_type_id, :additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_types) do
      column :additional_code_type_id, "varchar(1)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :application_code, "varchar(255)"
      column :meursing_table_plan_id, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:meursing_table_plan_id], :name=>:index_additional_code_types_on_meursing_table_plan_id
      index [:additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_codes) do
      column :additional_code_sid, "int(11)"
      column :additional_code_type_id, "varchar(1)"
      column :additional_code, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:additional_code_sid], :name=>:primary_key, :unique=>true
      index [:additional_code_type_id], :name=>:type_id
    end

    create_table(:base_regulations) do
      column :base_regulation_role, "int(11)"
      column :base_regulation_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :community_code, "int(11)"
      column :regulation_group_id, "varchar(255)"
      column :replacement_indicator, "int(11)"
      column :stopped_flag, "tinyint(1)"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :effective_end_date, "date"
      column :antidumping_regulation_role, "int(11)"
      column :related_antidumping_regulation_id, "varchar(255)"
      column :complete_abrogation_regulation_role, "int(11)"
      column :complete_abrogation_regulation_id, "varchar(255)"
      column :explicit_abrogation_regulation_role, "int(11)"
      column :explicit_abrogation_regulation_id, "varchar(255)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:antidumping_regulation_role, :related_antidumping_regulation_id], :name=>:antidumping_regulation
      index [:complete_abrogation_regulation_role, :complete_abrogation_regulation_id], :name=>:complete_abrogation_regulation
      index [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id], :name=>:explicit_abrogation_regulation
      index [:regulation_group_id], :name=>:index_base_regulations_on_regulation_group_id
      index [:base_regulation_id, :base_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_description_periods) do
      column :certificate_description_period_sid, "int(11)"
      column :certificate_type_code, "varchar(1)"
      column :certificate_code, "varchar(3)"
      column :validity_start_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"
      column :national, "tinyint(1)"

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:certificate_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_descriptions) do
      column :certificate_description_period_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :certificate_type_code, "varchar(1)"
      column :certificate_code, "varchar(3)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:language_id], :name=>:index_certificate_descriptions_on_language_id
      index [:certificate_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_type_descriptions) do
      column :certificate_type_code, "varchar(1)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_certificate_type_descriptions_on_language_id
      index [:certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_types) do
      column :certificate_type_code, "varchar(1)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:certificates) do
      column :certificate_type_code, "varchar(1)"
      column :certificate_code, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"
      column :national_abbrev, "varchar(255)"

      index [:certificate_code, :certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:chapter_notes) do
      primary_key :id, :type=>"int(11)"
      column :section_id, "int(11)"
      column :chapter_id, "int(11)"
      column :content, "text"

      index [:chapter_id]
      index [:section_id]
    end

    create_table(:chapters_sections) do
      column :goods_nomenclature_sid, "int(11)"
      column :section_id, "int(11)"

      index [:goods_nomenclature_sid, :section_id], :name=>:index_chapters_sections_on_goods_nomenclature_sid_and_section_id, :unique=>true
    end

    create_table(:chief_country_code) do
      column :chief_country_cd, "varchar(2)"
      column :country_cd, "varchar(2)"

      index [:chief_country_cd], :name=>:primary_key
    end

    create_table(:chief_country_group) do
      column :chief_country_grp, "varchar(4)"
      column :country_grp_region, "varchar(4)"
      column :country_exclusions, "varchar(100)"

      index [:chief_country_grp], :name=>:primary_key
    end

    create_table(:chief_duty_expression) do
      primary_key :id, :type=>"int(11)"
      column :adval1_rate, "tinyint(1)"
      column :adval2_rate, "tinyint(1)"
      column :spfc1_rate, "tinyint(1)"
      column :spfc2_rate, "tinyint(1)"
      column :duty_expression_id_spfc1, "varchar(2)"
      column :monetary_unit_code_spfc1, "varchar(3)"
      column :duty_expression_id_spfc2, "varchar(2)"
      column :monetary_unit_code_spfc2, "varchar(3)"
      column :duty_expression_id_adval1, "varchar(2)"
      column :monetary_unit_code_adval1, "varchar(3)"
      column :duty_expression_id_adval2, "varchar(2)"
      column :monetary_unit_code_adval2, "varchar(3)"
    end

    create_table(:chief_measure_type_adco) do
      column :measure_group_code, "varchar(2)"
      column :measure_type, "varchar(3)"
      column :tax_type_code, "varchar(11)"
      column :measure_type_id, "varchar(3)"
      column :adtnl_cd_type_id, "varchar(1)"
      column :adtnl_cd, "varchar(3)"
      column :zero_comp, "int(11)"
    end

    create_table(:chief_measure_type_cond) do
      column :measure_group_code, "varchar(2)"
      column :measure_type, "varchar(3)"
      column :cond_cd, "varchar(1)"
      column :comp_seq_no, "varchar(3)"
      column :cert_type_cd, "varchar(1)"
      column :cert_ref_no, "varchar(3)"
      column :act_cd, "varchar(2)"
    end

    create_table(:chief_measure_type_footnote) do
      primary_key :id, :type=>"int(11)"
      column :measure_type_id, "varchar(3)"
      column :footn_type_id, "varchar(2)"
      column :footn_id, "varchar(3)"
    end

    create_table(:chief_measurement_unit) do
      primary_key :id, :type=>"int(11)"
      column :spfc_cmpd_uoq, "varchar(3)"
      column :spfc_uoq, "varchar(3)"
      column :measurem_unit_cd, "varchar(3)"
      column :measurem_unit_qual_cd, "varchar(1)"
    end

    create_table(:chief_mfcm) do
      column :fe_tsmp, "datetime"
      column :msrgp_code, "varchar(5)"
      column :msr_type, "varchar(5)"
      column :tty_code, "varchar(5)"
      column :le_tsmp, "datetime"
      column :audit_tsmp, "datetime"
      column :cmdty_code, "varchar(12)"
      column :cmdty_msr_xhdg, "varchar(255)"
      column :null_tri_rqd, "varchar(255)"
      column :exports_use_ind, "tinyint(1)"
      column :tar_msr_no, "varchar(12)"
      column :transformed, "tinyint(1)", :default=>false
      column :amend_indicator, "varchar(1)"
      column :origin, "varchar(30)"

      index [:msrgp_code]
    end

    create_table(:chief_tame) do
      column :fe_tsmp, "datetime"
      column :msrgp_code, "varchar(5)"
      column :msr_type, "varchar(5)"
      column :tty_code, "varchar(5)"
      column :tar_msr_no, "varchar(12)"
      column :le_tsmp, "datetime"
      column :adval_rate, "decimal(8,3)"
      column :alch_sgth, "decimal(8,3)"
      column :audit_tsmp, "datetime"
      column :cap_ai_stmt, "varchar(255)"
      column :cap_max_pct, "decimal(8,3)"
      column :cmdty_msr_xhdg, "varchar(255)"
      column :comp_mthd, "varchar(255)"
      column :cpc_wvr_phb, "varchar(255)"
      column :ec_msr_set, "varchar(255)"
      column :mip_band_exch, "varchar(255)"
      column :mip_rate_exch, "varchar(255)"
      column :mip_uoq_code, "varchar(255)"
      column :nba_id, "varchar(255)"
      column :null_tri_rqd, "varchar(255)"
      column :qta_code_uk, "varchar(255)"
      column :qta_elig_use, "varchar(255)"
      column :qta_exch_rate, "varchar(255)"
      column :qta_no, "varchar(255)"
      column :qta_uoq_code, "varchar(255)"
      column :rfa, "text"
      column :rfs_code_1, "varchar(255)"
      column :rfs_code_2, "varchar(255)"
      column :rfs_code_3, "varchar(255)"
      column :rfs_code_4, "varchar(255)"
      column :rfs_code_5, "varchar(255)"
      column :tdr_spr_sur, "varchar(255)"
      column :exports_use_ind, "tinyint(1)"
      column :transformed, "tinyint(1)", :default=>false
      column :amend_indicator, "varchar(1)"
      column :origin, "varchar(30)"

      index [:msrgp_code, :msr_type, :tty_code, :tar_msr_no, :fe_tsmp], :name=>:index_chief_tame
    end

    create_table(:chief_tamf) do
      column :fe_tsmp, "datetime"
      column :msrgp_code, "varchar(5)"
      column :msr_type, "varchar(5)"
      column :tty_code, "varchar(5)"
      column :tar_msr_no, "varchar(12)"
      column :le_tsmp, "datetime"
      column :adval1_rate, "decimal(8,3)"
      column :adval2_rate, "decimal(8,3)"
      column :ai_factor, "varchar(255)"
      column :cmdty_dmql, "decimal(8,3)"
      column :cmdty_dmql_uoq, "varchar(255)"
      column :cngp_code, "varchar(255)"
      column :cntry_disp, "varchar(255)"
      column :cntry_orig, "varchar(255)"
      column :duty_type, "varchar(255)"
      column :ec_supplement, "varchar(255)"
      column :ec_exch_rate, "varchar(255)"
      column :spcl_inst, "varchar(255)"
      column :spfc1_cmpd_uoq, "varchar(255)"
      column :spfc1_rate, "decimal(7,4)"
      column :spfc1_uoq, "varchar(255)"
      column :spfc2_rate, "decimal(7,4)"
      column :spfc2_uoq, "varchar(255)"
      column :spfc3_rate, "decimal(7,4)"
      column :spfc3_uoq, "varchar(255)"
      column :tamf_dt, "varchar(255)"
      column :tamf_sta, "varchar(255)"
      column :tamf_ty, "varchar(255)"
      column :transformed, "tinyint(1)", :default=>false
      column :amend_indicator, "varchar(1)"
      column :origin, "varchar(30)"

      index [:fe_tsmp, :msrgp_code, :msr_type, :tty_code, :tar_msr_no, :amend_indicator], :name=>:index_chief_tamf
    end

    create_table(:complete_abrogation_regulations) do
      column :complete_abrogation_regulation_role, "int(11)"
      column :complete_abrogation_regulation_id, "varchar(255)"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :replacement_indicator, "int(11)"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:duty_expression_descriptions) do
      column :duty_expression_id, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_duty_expression_descriptions_on_language_id
      index [:duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:duty_expressions) do
      column :duty_expression_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :duty_amount_applicability_code, "int(11)"
      column :measurement_unit_applicability_code, "int(11)"
      column :monetary_unit_applicability_code, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:explicit_abrogation_regulations) do
      column :explicit_abrogation_regulation_role, "int(11)"
      column :explicit_abrogation_regulation_id, "varchar(8)"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :replacement_indicator, "int(11)"
      column :abrogation_date, "date"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_description_periods) do
      column :export_refund_nomenclature_description_period_sid, "int(11)"
      column :export_refund_nomenclature_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :additional_code_type, "varchar(255)"
      column :export_refund_code, "varchar(255)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:export_refund_nomenclature_sid, :export_refund_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_descriptions) do
      column :export_refund_nomenclature_description_period_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :export_refund_nomenclature_sid, "int(11)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :additional_code_type, "varchar(255)"
      column :export_refund_code, "varchar(255)"
      column :productline_suffix, "varchar(2)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:export_refund_nomenclature_sid], :name=>:export_refund_nomenclature
      index [:language_id], :name=>:index_export_refund_nomenclature_descriptions_on_language_id
      index [:export_refund_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_indents) do
      column :export_refund_nomenclature_indents_sid, "int(11)"
      column :export_refund_nomenclature_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :number_export_refund_nomenclature_indents, "varchar(255)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :additional_code_type, "varchar(255)"
      column :export_refund_code, "varchar(255)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:export_refund_nomenclature_indents_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclatures) do
      column :export_refund_nomenclature_sid, "int(11)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :additional_code_type, "varchar(1)"
      column :export_refund_code, "varchar(3)"
      column :productline_suffix, "varchar(2)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :goods_nomenclature_sid, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_sid], :name=>:index_export_refund_nomenclatures_on_goods_nomenclature_sid
      index [:export_refund_nomenclature_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_additional_codes) do
      column :additional_code_sid, "int(11)"
      column :footnote_type_id, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :additional_code_type_id, "varchar(255)"
      column :additional_code, "varchar(3)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:additional_code_type_id], :name=>:additional_code_type
      index [:footnote_id, :footnote_type_id, :additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_erns) do
      column :export_refund_nomenclature_sid, "int(11)"
      column :footnote_type, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :additional_code_type, "varchar(255)"
      column :export_refund_code, "varchar(255)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:export_refund_nomenclature_sid, :footnote_id, :footnote_type, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_goods_nomenclatures) do
      column :goods_nomenclature_sid, "int(11)"
      column :footnote_type, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:footnote_id, :footnote_type, :goods_nomenclature_sid, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_measures) do
      column :measure_sid, "int(11)"
      column :footnote_type_id, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:footnote_id], :name=>:footnote_id
      index [:measure_sid], :name=>:measure_sid
    end

    create_table(:footnote_association_meursing_headings) do
      column :meursing_table_plan_id, "varchar(2)"
      column :meursing_heading_number, "varchar(255)"
      column :row_column_code, "int(11)"
      column :footnote_type, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:footnote_id, :meursing_table_plan_id], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_description_periods) do
      column :footnote_description_period_sid, "int(11)"
      column :footnote_type_id, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"
      column :national, "tinyint(1)"

      index [:footnote_id, :footnote_type_id, :footnote_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_descriptions) do
      column :footnote_description_period_sid, "int(11)"
      column :footnote_type_id, "varchar(2)"
      column :footnote_id, "varchar(3)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_footnote_descriptions_on_language_id
      index [:footnote_id, :footnote_type_id, :footnote_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_type_descriptions) do
      column :footnote_type_id, "varchar(2)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_footnote_type_descriptions_on_language_id
      index [:footnote_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_types) do
      column :footnote_type_id, "varchar(2)"
      column :application_code, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:footnote_type_id], :name=>:primary_key
    end

    create_table(:footnotes) do
      column :footnote_id, "varchar(3)"
      column :footnote_type_id, "varchar(2)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:footnote_id, :footnote_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:fts_regulation_actions) do
      column :fts_regulation_role, "int(11)"
      column :fts_regulation_id, "varchar(8)"
      column :stopped_regulation_role, "int(11)"
      column :stopped_regulation_id, "varchar(8)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:fts_regulation_id, :fts_regulation_role, :stopped_regulation_id, :stopped_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:full_temporary_stop_regulations) do
      column :full_temporary_stop_regulation_role, "int(11)"
      column :full_temporary_stop_regulation_id, "varchar(8)"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :effective_enddate, "date"
      column :explicit_abrogation_regulation_role, "int(11)"
      column :explicit_abrogation_regulation_id, "varchar(8)"
      column :replacement_indicator, "int(11)"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id], :name=>:explicit_abrogation_regulation
      index [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_description_periods) do
      column :geographical_area_description_period_sid, "int(11)"
      column :geographical_area_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :geographical_area_id, "varchar(255)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"
      column :national, "tinyint(1)"

      index [:geographical_area_description_period_sid, :geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_descriptions) do
      column :geographical_area_description_period_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :geographical_area_sid, "int(11)"
      column :geographical_area_id, "varchar(255)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_geographical_area_descriptions_on_language_id
      index [:geographical_area_description_period_sid, :geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_memberships) do
      column :geographical_area_sid, "int(11)"
      column :geographical_area_group_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:geographical_area_sid, :geographical_area_group_sid, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_areas) do
      column :geographical_area_sid, "int(11)"
      column :parent_geographical_area_group_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :geographical_code, "varchar(255)"
      column :geographical_area_id, "varchar(255)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:geographical_area_id], :name=>:geographical_area_id, :unique=>true
      index [:parent_geographical_area_group_sid], :name=>:index_geographical_areas_on_parent_geographical_area_group_sid
      index [:geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_description_periods) do
      column :goods_nomenclature_description_period_sid, "int(11)"
      column :goods_nomenclature_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:goods_nomenclature_sid, :validity_start_date, :validity_end_date], :name=>:goods_nomenclature
      index [:goods_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_descriptions) do
      column :goods_nomenclature_description_period_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :goods_nomenclature_sid, "int(11)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_goods_nomenclature_descriptions_on_language_id
      index [:goods_nomenclature_sid, :goods_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_group_descriptions) do
      column :goods_nomenclature_group_type, "varchar(1)"
      column :goods_nomenclature_group_id, "varchar(6)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_goods_nomenclature_group_descriptions_on_language_id
      index [:goods_nomenclature_group_id, :goods_nomenclature_group_type], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_groups) do
      column :goods_nomenclature_group_type, "varchar(1)"
      column :goods_nomenclature_group_id, "varchar(6)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :nomenclature_group_facility_code, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_group_id, :goods_nomenclature_group_type], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_indents) do
      column :goods_nomenclature_indent_sid, "int(11)"
      column :goods_nomenclature_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :number_indents, "int(11)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:goods_nomenclature_sid], :name=>:goods_nomenclature_sid
      index [:validity_start_date, :validity_end_date], :name=>:goods_nomenclature_validity_dates
      index [:goods_nomenclature_indent_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_origins) do
      column :goods_nomenclature_sid, "int(11)"
      column :derived_goods_nomenclature_item_id, "varchar(10)"
      column :derived_productline_suffix, "varchar(2)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_sid, :derived_goods_nomenclature_item_id, :derived_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_successors) do
      column :goods_nomenclature_sid, "int(11)"
      column :absorbed_goods_nomenclature_item_id, "varchar(10)"
      column :absorbed_productline_suffix, "varchar(2)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_sid, :absorbed_goods_nomenclature_item_id, :absorbed_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclatures) do
      column :goods_nomenclature_sid, "int(11)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :producline_suffix, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :statistical_indicator, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_item_id, :producline_suffix], :name=>:item_id
      index [:goods_nomenclature_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:language_descriptions) do
      column :language_code_id, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id, :language_code_id], :name=>:primary_key, :unique=>true
    end

    create_table(:languages) do
      column :language_id, "varchar(5)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
    end

    create_table(:measure_action_descriptions) do
      column :action_code, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:action_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_actions) do
      column :action_code, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:action_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_components) do
      column :measure_sid, "int(11)"
      column :duty_expression_id, "varchar(255)"
      column :duty_amount, "double"
      column :monetary_unit_code, "varchar(255)"
      column :measurement_unit_code, "varchar(3)"
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_code], :name=>:index_measure_components_on_measurement_unit_code
      index [:measurement_unit_qualifier_code], :name=>:index_measure_components_on_measurement_unit_qualifier_code
      index [:monetary_unit_code], :name=>:index_measure_components_on_monetary_unit_code
      index [:measure_sid, :duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_code_descriptions) do
      column :condition_code, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:condition_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_codes) do
      column :condition_code, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:condition_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_components) do
      column :measure_condition_sid, "int(11)"
      column :duty_expression_id, "varchar(255)"
      column :duty_amount, "double"
      column :monetary_unit_code, "varchar(255)"
      column :measurement_unit_code, "varchar(3)"
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:duty_expression_id], :name=>:index_measure_condition_components_on_duty_expression_id
      index [:measurement_unit_code], :name=>:index_measure_condition_components_on_measurement_unit_code
      index [:monetary_unit_code], :name=>:index_measure_condition_components_on_monetary_unit_code
      index [:measurement_unit_qualifier_code], :name=>:measurement_unit_qualifier_code
      index [:measure_condition_sid, :duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_conditions) do
      column :measure_condition_sid, "int(11)"
      column :measure_sid, "int(11)"
      column :condition_code, "varchar(255)"
      column :component_sequence_number, "int(11)"
      column :condition_duty_amount, "double"
      column :condition_monetary_unit_code, "varchar(255)"
      column :condition_measurement_unit_code, "varchar(3)"
      column :condition_measurement_unit_qualifier_code, "varchar(1)"
      column :action_code, "varchar(255)"
      column :certificate_type_code, "varchar(1)"
      column :certificate_code, "varchar(3)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:condition_measurement_unit_qualifier_code], :name=>:condition_measurement_unit_qualifier_code
      index [:action_code], :name=>:index_measure_conditions_on_action_code
      index [:condition_measurement_unit_code], :name=>:index_measure_conditions_on_condition_measurement_unit_code
      index [:condition_monetary_unit_code], :name=>:index_measure_conditions_on_condition_monetary_unit_code
      index [:measure_sid], :name=>:index_measure_conditions_on_measure_sid
      index [:measure_condition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_excluded_geographical_areas) do
      column :measure_sid, "int(11)"
      column :excluded_geographical_area, "varchar(255)"
      column :geographical_area_sid, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:geographical_area_sid], :name=>:geographical_area_sid
      index [:measure_sid, :excluded_geographical_area, :geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_partial_temporary_stops) do
      column :measure_sid, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :partial_temporary_stop_regulation_id, "varchar(255)"
      column :partial_temporary_stop_regulation_officialjournal_number, "varchar(255)"
      column :partial_temporary_stop_regulation_officialjournal_page, "int(11)"
      column :abrogation_regulation_id, "varchar(255)"
      column :abrogation_regulation_officialjournal_number, "varchar(255)"
      column :abrogation_regulation_officialjournal_page, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:abrogation_regulation_id], :name=>:abrogation_regulation_id
      index [:measure_sid, :partial_temporary_stop_regulation_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_descriptions) do
      column :measure_type_id, "varchar(3)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_measure_type_descriptions_on_language_id
      index [:measure_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_series) do
      column :measure_type_series_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :measure_type_combination, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measure_type_series_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_series_descriptions) do
      column :measure_type_series_id, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_measure_type_series_descriptions_on_language_id
      index [:measure_type_series_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_types) do
      column :measure_type_id, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :trade_movement_code, "int(11)"
      column :priority_code, "int(11)"
      column :measure_component_applicable_code, "int(11)"
      column :origin_dest_code, "int(11)"
      column :order_number_capture_code, "int(11)"
      column :measure_explosion_level, "int(11)"
      column :measure_type_series_id, "varchar(255)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"
      column :measure_type_acronym, "varchar(3)"

      index [:measure_type_series_id], :name=>:index_measure_types_on_measure_type_series_id
      index [:measure_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_descriptions) do
      column :measurement_unit_code, "varchar(3)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_measurement_unit_descriptions_on_language_id
      index [:measurement_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_qualifier_descriptions) do
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_qualifiers) do
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_units) do
      column :measurement_unit_code, "varchar(3)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurements) do
      column :measurement_unit_code, "varchar(3)"
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_code, :measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measures) do
      column :measure_sid, "int(11)"
      column :measure_type, "varchar(3)"
      column :geographical_area, "varchar(255)"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :measure_generating_regulation_role, "int(11)"
      column :measure_generating_regulation_id, "varchar(255)"
      column :justification_regulation_role, "int(11)"
      column :justification_regulation_id, "varchar(255)"
      column :stopped_flag, "tinyint(1)"
      column :geographical_area_sid, "int(11)"
      column :goods_nomenclature_sid, "int(11)"
      column :ordernumber, "varchar(255)"
      column :additional_code_type, "varchar(255)"
      column :additional_code, "varchar(3)"
      column :additional_code_sid, "int(11)"
      column :reduction_indicator, "int(11)"
      column :export_refund_nomenclature_sid, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:additional_code_sid], :name=>:index_measures_on_additional_code_sid
      index [:geographical_area_sid], :name=>:index_measures_on_geographical_area_sid
      index [:goods_nomenclature_sid], :name=>:index_measures_on_goods_nomenclature_sid
      index [:measure_type], :name=>:index_measures_on_measure_type
      index [:justification_regulation_role, :justification_regulation_id], :name=>:justification_regulation
      index [:measure_generating_regulation_id], :name=>:measure_generating_regulation
      index [:export_refund_nomenclature_sid]
      index [:goods_nomenclature_item_id]
      index [:measure_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_additional_codes) do
      column :meursing_additional_code_sid, "int(11)"
      column :additional_code, "int(11)"
      column :validity_start_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :validity_end_date, "datetime"

      index [:meursing_additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_heading_texts) do
      column :meursing_table_plan_id, "varchar(2)"
      column :meursing_heading_number, "int(11)"
      column :row_column_code, "int(11)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_headings) do
      column :meursing_table_plan_id, "varchar(2)"
      column :meursing_heading_number, "int(11)"
      column :row_column_code, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_subheadings) do
      column :meursing_table_plan_id, "varchar(2)"
      column :meursing_heading_number, "int(11)"
      column :row_column_code, "int(11)"
      column :subheading_sequence_number, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code, :subheading_sequence_number], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_table_cell_components) do
      column :meursing_additional_code_sid, "int(11)"
      column :meursing_table_plan_id, "varchar(2)"
      column :heading_number, "int(11)"
      column :row_column_code, "int(11)"
      column :subheading_sequence_number, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :additional_code, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:meursing_table_plan_id, :heading_number, :row_column_code, :meursing_additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_table_plans) do
      column :meursing_table_plan_id, "varchar(2)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:meursing_table_plan_id], :name=>:primary_key, :unique=>true
    end

    create_table(:modification_regulations) do
      column :modification_regulation_role, "int(11)"
      column :modification_regulation_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :base_regulation_role, "int(11)"
      column :base_regulation_id, "varchar(255)"
      column :replacement_indicator, "int(11)"
      column :stopped_flag, "tinyint(1)"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :explicit_abrogation_regulation_role, "int(11)"
      column :explicit_abrogation_regulation_id, "varchar(8)"
      column :effective_end_date, "date"
      column :complete_abrogation_regulation_role, "int(11)"
      column :complete_abrogation_regulation_id, "varchar(8)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:base_regulation_id, :base_regulation_role], :name=>:base_regulation
      index [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role], :name=>:complete_abrogation_regulation
      index [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role], :name=>:explicit_abrogation_regulation
      index [:modification_regulation_id, :modification_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_exchange_periods) do
      column :monetary_exchange_period_sid, "int(11)"
      column :parent_monetary_unit_code, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:monetary_exchange_period_sid, :parent_monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_exchange_rates) do
      column :monetary_exchange_period_sid, "int(11)"
      column :child_monetary_unit_code, "varchar(255)"
      column :exchange_rate, "decimal(16,8)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:monetary_exchange_period_sid, :child_monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_unit_descriptions) do
      column :monetary_unit_code, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:language_id], :name=>:index_monetary_unit_descriptions_on_language_id
      index [:monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_units) do
      column :monetary_unit_code, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:nomenclature_group_memberships) do
      column :goods_nomenclature_sid, "int(11)"
      column :goods_nomenclature_group_type, "varchar(1)"
      column :goods_nomenclature_group_id, "varchar(6)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :goods_nomenclature_item_id, "varchar(10)"
      column :productline_suffix, "varchar(2)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:goods_nomenclature_sid, :goods_nomenclature_group_id, :goods_nomenclature_group_type, :goods_nomenclature_item_id, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:prorogation_regulation_actions) do
      column :prorogation_regulation_role, "int(11)"
      column :prorogation_regulation_id, "varchar(8)"
      column :prorogated_regulation_role, "int(11)"
      column :prorogated_regulation_id, "varchar(8)"
      column :prorogated_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:prorogation_regulation_id, :prorogation_regulation_role, :prorogated_regulation_id, :prorogated_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:prorogation_regulations) do
      column :prorogation_regulation_role, "int(11)"
      column :prorogation_regulation_id, "varchar(255)"
      column :published_date, "date"
      column :officialjournal_number, "varchar(255)"
      column :officialjournal_page, "int(11)"
      column :replacement_indicator, "int(11)"
      column :information_text, "text"
      column :approved_flag, "tinyint(1)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:prorogation_regulation_id, :prorogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_associations) do
      column :main_quota_definition_sid, "int(11)"
      column :sub_quota_definition_sid, "int(11)"
      column :relation_type, "varchar(255)"
      column :coefficient, "decimal(16,5)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:main_quota_definition_sid, :sub_quota_definition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_balance_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :last_import_date_in_allocation, "date"
      column :old_balance, "int(11)"
      column :new_balance, "int(11)"
      column :imported_amount, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_blocking_periods) do
      column :quota_blocking_period_sid, "int(11)"
      column :quota_definition_sid, "int(11)"
      column :blocking_start_date, "date"
      column :blocking_end_date, "date"
      column :blocking_period_type, "int(11)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_blocking_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_critical_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :critical_state, "varchar(255)"
      column :critical_state_change_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_definitions) do
      column :quota_definition_sid, "int(11)"
      column :quota_order_number_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :quota_order_number_sid, "int(11)"
      column :volume, "int(11)"
      column :initial_volume, "int(11)"
      column :measurement_unit_code, "varchar(3)"
      column :maximum_precision, "int(11)"
      column :critical_state, "varchar(255)"
      column :critical_threshold, "int(11)"
      column :monetary_unit_code, "varchar(255)"
      column :measurement_unit_qualifier_code, "varchar(1)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:measurement_unit_code], :name=>:index_quota_definitions_on_measurement_unit_code
      index [:measurement_unit_qualifier_code], :name=>:index_quota_definitions_on_measurement_unit_qualifier_code
      index [:monetary_unit_code], :name=>:index_quota_definitions_on_monetary_unit_code
      index [:quota_order_number_id], :name=>:index_quota_definitions_on_quota_order_number_id
      index [:quota_definition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_exhaustion_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :exhaustion_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_number_origin_exclusions) do
      column :quota_order_number_origin_sid, "int(11)"
      column :excluded_geographical_area_sid, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_order_number_origin_sid, :excluded_geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_number_origins) do
      column :quota_order_number_origin_sid, "int(11)"
      column :quota_order_number_sid, "int(11)"
      column :geographical_area_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :geographical_area_sid, "int(11)"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:geographical_area_sid], :name=>:index_quota_order_number_origins_on_geographical_area_sid
      index [:quota_order_number_origin_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_numbers) do
      column :quota_order_number_sid, "int(11)"
      column :quota_order_number_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_order_number_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_reopening_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :reopening_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_suspension_periods) do
      column :quota_suspension_period_sid, "int(11)"
      column :quota_definition_sid, "int(11)"
      column :suspension_start_date, "date"
      column :suspension_end_date, "date"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid], :name=>:index_quota_suspension_periods_on_quota_definition_sid
      index [:quota_suspension_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_unblocking_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :unblocking_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_unsuspension_events) do
      column :quota_definition_sid, "int(11)"
      column :occurrence_timestamp, "datetime"
      column :unsuspension_date, "date"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_group_descriptions) do
      column :regulation_group_id, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_regulation_group_descriptions_on_language_id
      index [:regulation_group_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_groups) do
      column :regulation_group_id, "varchar(255)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:regulation_group_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_replacements) do
      column :geographical_area_id, "varchar(255)"
      column :chapter_heading, "varchar(255)"
      column :replacing_regulation_role, "int(11)"
      column :replacing_regulation_id, "varchar(255)"
      column :replaced_regulation_role, "int(11)"
      column :replaced_regulation_id, "varchar(255)"
      column :measure_type_id, "varchar(3)"
      column :created_at, "datetime"
      column :updated_at, "datetime"
    end

    create_table(:regulation_role_type_descriptions) do
      column :regulation_role_type_id, "varchar(255)"
      column :language_id, "varchar(5)"
      column :description, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:language_id], :name=>:index_regulation_role_type_descriptions_on_language_id
      index [:regulation_role_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_role_types) do
      column :regulation_role_type_id, "int(11)"
      column :validity_start_date, "datetime"
      column :validity_end_date, "datetime"
      column :created_at, "datetime"
      column :updated_at, "datetime"
      column :national, "tinyint(1)"

      index [:regulation_role_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false

      primary_key [:filename]
    end

    self[:schema_migrations].insert(:filename => "1342519058_create_schema.rb")
    self[:schema_migrations].insert(:filename => "20120726092749_duty_amount_expressed_in_float.rb")
    self[:schema_migrations].insert(:filename => "20120726162358_measure_sid_to_be_unsigned.rb")
    self[:schema_migrations].insert(:filename => "20120730121153_add_gono_id_index_on_measures.rb")
    self[:schema_migrations].insert(:filename => "20120803132451_fix_chief_columns.rb")
    self[:schema_migrations].insert(:filename => "20120805223427_rename_qta_elig_use_lstrubg_chief.rb")
    self[:schema_migrations].insert(:filename => "20120805224946_add_transformed_to_chief_tables.rb")
    self[:schema_migrations].insert(:filename => "20120806141008_add_note_tables.rb")
    self[:schema_migrations].insert(:filename => "20120807111730_add_national_attributes.rb")
    self[:schema_migrations].insert(:filename => "20120810083616_fix_datatypes.rb")
    self[:schema_migrations].insert(:filename => "20120810085137_add_national_abbreviation_to_certificates.rb")
    self[:schema_migrations].insert(:filename => "20120810104725_create_add_acronym_to_measure_types.rb")
    self[:schema_migrations].insert(:filename => "20120810105500_adjust_fields_for_chief.rb")
    self[:schema_migrations].insert(:filename => "20120810114211_add_national_to_certificate_description_periods.rb")
    self[:schema_migrations].insert(:filename => "20120820074642_create_search_references.rb")
    self[:schema_migrations].insert(:filename => "20120820181332_measure_sid_should_be_signed.rb")
    self[:schema_migrations].insert(:filename => "20120821151733_add_amend_indicator_to_chief.rb")
    self[:schema_migrations].insert(:filename => "20120823142700_change_decimals_in_chief.rb")
    self[:schema_migrations].insert(:filename => "20120911111821_change_chief_duty_expressions_to_boolean.rb")
    self[:schema_migrations].insert(:filename => "20120912143520_add_indexes_to_chief_records.rb")
    self[:schema_migrations].insert(:filename => "20120913170136_add_national_to_measures.rb")
    self[:schema_migrations].insert(:filename => "20120919073610_remove_export_indication_from_measures.rb")
    self[:schema_migrations].insert(:filename => "20120921072412_export_refund_changes.rb")
    self[:schema_migrations].insert(:filename => "20121001141720_adjust_chief_keys.rb")
    self[:schema_migrations].insert(:filename => "20121003061643_add_origin_to_chief_records.rb")
    self[:schema_migrations].insert(:filename => "20121004111601_create_tariff_updates.rb")

    create_table(:search_references) do
      primary_key :id, :type=>"int(11)"
      column :title, "varchar(255)"
      column :reference, "varchar(255)"
    end

    create_table(:section_notes) do
      primary_key :id, :type=>"int(11)"
      column :section_id, "int(11)"
      column :content, "text"

      index [:section_id]
    end

    create_table(:sections) do
      primary_key :id, :type=>"int(11)"
      column :position, "int(11)"
      column :numeral, "varchar(255)"
      column :title, "varchar(255)"
      column :created_at, "datetime", :null=>false
      column :updated_at, "datetime", :null=>false
    end

    create_table(:tariff_updates) do
      column :filename, "varchar(30)", :null=>false
      column :update_type, "varchar(15)"
      column :state, "varchar(1)"
      column :issue_date, "date"
      column :updated_at, "datetime"
      column :created_at, "datetime"

      primary_key [:filename]
    end

    create_table(:transmission_comments) do
      column :comment_sid, "int(11)"
      column :language_id, "varchar(5)"
      column :comment_text, "text"
      column :created_at, "datetime"
      column :updated_at, "datetime"

      index [:comment_sid, :language_id], :name=>:primary_key
    end
  end
end

