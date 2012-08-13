Sequel.migration do
  change do
    create_table(:additional_code_description_periods, :ignore_index_errors=>false) do
      Integer :additional_code_description_period_sid
      Integer :additional_code_sid
      String :additional_code_type_id, :size=>1
      String :additional_code, :size=>3
      DateTime :validity_start_date
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:additional_code_type_id], :name=>:code_type_id
      index [:additional_code_description_period_sid], :name=>:description_period_sid
      index [:additional_code_description_period_sid, :additional_code_sid, :additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_descriptions, :ignore_index_errors=>false) do
      Integer :additional_code_description_period_sid
      String :language_id, :size=>5
      Integer :additional_code_sid
      String :additional_code_type_id, :size=>1
      String :additional_code, :size=>3
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:language_id
      index [:additional_code_description_period_sid], :name=>:period_sid
      index [:additional_code_description_period_sid, :additional_code_sid], :name=>:primary_key, :unique=>true
      index [:additional_code_sid], :name=>:sid
      index [:additional_code_type_id], :name=>:type_id
    end

    create_table(:additional_code_type_descriptions, :ignore_index_errors=>false) do
      String :additional_code_type_id, :size=>1
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_additional_code_type_descriptions_on_language_id
      index [:additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_type_measure_types, :ignore_index_errors=>false) do
      String :measure_type_id, :size=>3
      String :additional_code_type_id, :size=>1
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:measure_type_id, :additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_code_types, :ignore_index_errors=>false) do
      String :additional_code_type_id, :size=>1
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :application_code, :size=>255
      String :meursing_table_plan_id, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id], :name=>:index_additional_code_types_on_meursing_table_plan_id
      index [:additional_code_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:additional_codes, :ignore_index_errors=>false) do
      Integer :additional_code_sid
      String :additional_code_type_id, :size=>1
      String :additional_code, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:additional_code_sid], :name=>:primary_key, :unique=>true
      index [:additional_code_type_id], :name=>:type_id
    end

    create_table(:base_regulations, :ignore_index_errors=>false) do
      Integer :base_regulation_role
      String :base_regulation_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :community_code
      String :regulation_group_id, :size=>255
      Integer :replacement_indicator
      TrueClass :stopped_flag
      String :information_text, :text=>true
      TrueClass :approved_flag
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      Date :effective_end_date
      Integer :antidumping_regulation_role
      String :related_antidumping_regulation_id, :size=>255
      Integer :complete_abrogation_regulation_role
      String :complete_abrogation_regulation_id, :size=>255
      Integer :explicit_abrogation_regulation_role
      String :explicit_abrogation_regulation_id, :size=>255
      DateTime :created_at
      DateTime :updated_at

      index [:antidumping_regulation_role, :related_antidumping_regulation_id], :name=>:antidumping_regulation
      index [:complete_abrogation_regulation_role, :complete_abrogation_regulation_id], :name=>:complete_abrogation_regulation
      index [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id], :name=>:explicit_abrogation_regulation
      index [:regulation_group_id], :name=>:index_base_regulations_on_regulation_group_id
      index [:base_regulation_id, :base_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_description_periods, :ignore_index_errors=>false) do
      Integer :certificate_description_period_sid
      String :certificate_type_code, :size=>1
      String :certificate_code, :size=>3
      DateTime :validity_start_date
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:certificate_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_descriptions, :ignore_index_errors=>false) do
      Integer :certificate_description_period_sid
      String :language_id, :size=>5
      String :certificate_type_code, :size=>1
      String :certificate_code, :size=>3
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:language_id], :name=>:index_certificate_descriptions_on_language_id
      index [:certificate_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_type_descriptions, :ignore_index_errors=>false) do

      String :certificate_type_code, :size=>1
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_certificate_type_descriptions_on_language_id
      index [:certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:certificate_types, :ignore_index_errors=>false) do
      String :certificate_type_code, :size=>1
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:certificates, :ignore_index_errors=>false) do
      String :certificate_type_code, :size=>1
      String :certificate_code, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:certificate_code, :certificate_type_code], :name=>:primary_key, :unique=>true
    end

    create_table(:chapters_sections, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      Integer :section_id

      index [:goods_nomenclature_sid, :section_id], :name=>:index_chapters_sections_on_goods_nomenclature_sid_and_section_id, :unique=>true
    end

    create_table(:chief_country_code) do
      String :chief_country_cd, :size=>2
      String :country_cd, :size=>2
      index :chief_country_cd, :name=>:primary_key
    end

    create_table(:chief_country_group) do
      String :chief_country_grp, :size=>4
      String :country_grp_region, :size=>4
      String :country_exclusions, :size=>100
      index :chief_country_grp, :name=>:primary_key
    end

    create_table(:chief_duty_expression) do
      primary_key :id
      Integer :adval1_rate
      Integer :adval2_rate
      Integer :spfc1_rate
      Integer :spfc2_rate
      String :duty_expression_id_spfc1, :size => 2
      String :monetary_unit_code_spfc1, :size => 3
      String :duty_expression_id_spfc2, :size => 2
      String :monetary_unit_code_spfc2, :size => 3
      String :duty_expression_id_adval1, :size => 2
      String :monetary_unit_code_adval1, :size => 3
      String :duty_expression_id_adval2, :size => 2
      String :monetary_unit_code_adval2, :size => 3
    end

    create_table(:chief_measurement_unit) do
      primary_key :id
      String :spfc_cmpd_uoq, :size => 3
      String :spfc_uoq, :size => 3
      String :measurem_unit_cd, :size => 3
      String :measurem_unit_qual_cd, :size => 1
    end

    create_table(:chief_measure_type_adco) do
      String :measure_group_code, :size => 2
      String :measure_type, :size => 3
      String :tax_type_code, :size => 11
      String :measure_type_id, :size => 3
      String :adtnl_cd_type_id, :size => 1
      String :adtnl_cd, :size => 3
      Integer :zero_comp
    end

    create_table(:chief_measure_type_cond) do
      String :measure_group_code, :size => 2
      String :measure_type, :size => 3
      String :cond_cd, :size => 1
      String :comp_seq_no, :size => 3
      String :cert_type_cd, :size => 1
      String :cert_ref_no, :size => 3
      String :act_cd, :size => 2
    end

    create_table(:chief_measure_type_footnote) do
      primary_key :id
      String :measure_type_id, :size => 3
      String :footn_type_id, :size => 2
      String :footn_id, :size => 3
    end

    create_table(:chief_mfcm) do
      DateTime :fe_tsmp
      String :msrgp_code, :size=>255
      String :msr_type, :size=>255
      String :tty_code, :size=>255
      DateTime :le_tsmp
      DateTime :audit_tsmp
      String :cmdty_code, :size=>255
      String :cmdty_msr_xhdg, :size=>255
      String :null_tri_rqd, :size=>255
      TrueClass :exports_use_ind
    end

    create_table(:chief_tame) do
      DateTime :fe_tsmp
      String :msrgp_code, :size=>255
      String :msr_type, :size=>255
      String :tty_code, :size=>255
      String :tar_msr_no, :size=>255
      DateTime :le_tsmp
      BigDecimal :adval_rate, :size=>[3, 3]
      BigDecimal :alch_sgth, :size=>[3, 2]
      DateTime :audit_tsmp
      String :cap_ai_stmt, :size=>255
      BigDecimal :cap_max_pct, :size=>[3, 3]
      String :cmdty_msr_xhdg, :size=>255
      String :comp_mthd, :size=>255
      String :cpc_wvr_phb, :size=>255
      String :ec_msr_set, :size=>255
      String :mip_band_exch, :size=>255
      String :mip_rate_exch, :size=>255
      String :mip_uoq_code, :size=>255
      String :nba_id, :size=>255
      String :null_tri_rqd, :size=>255
      String :qta_code_uk, :size=>255
      String :qta_elig_useLstrubg, :size=>255
      String :qta_exch_rate, :size=>255
      String :qta_no, :size=>255
      String :qta_uoq_code, :size=>255
      String :rfa, :text=>true
      String :rfs_code_1, :size=>255
      String :rfs_code_2, :size=>255
      String :rfs_code_3, :size=>255
      String :rfs_code_4, :size=>255
      String :rfs_code_5, :size=>255
      String :tdr_spr_sur, :size=>255
      TrueClass :exports_use_ind
    end

    create_table(:chief_tamf) do
      DateTime :fe_tsmp
      String :msrgp_code, :size=>255
      String :msr_type, :size=>255
      String :tty_code, :size=>255
      String :tar_msr_no, :size=>255
      DateTime :le_tsmp
      BigDecimal :adval1_rate, :size=>[3, 3]
      BigDecimal :adval2_rate, :size=>[3, 3]
      String :ai_factor, :size=>255
      BigDecimal :cmdty_dmql, :size=>[8, 3]
      String :cmdty_dmql_uoq, :size=>255
      String :cngp_code, :size=>255
      String :cntry_disp, :size=>255
      String :cntry_orig, :size=>255
      String :duty_type, :size=>255
      String :ec_supplement, :size=>255
      String :ec_exch_rate, :size=>255
      String :spcl_inst, :size=>255
      String :spfc1_cmpd_uoq, :size=>255
      BigDecimal :spfc1_rate, :size=>[7, 4]
      String :spfc1_uoq, :size=>255
      BigDecimal :spfc2_rate, :size=>[7, 4]
      String :spfc2_uoq, :size=>255
      BigDecimal :spfc3_rate, :size=>[7, 4]
      String :spfc3_uoq, :size=>255
      String :tamf_dt, :size=>255
      String :tamf_sta, :size=>255
      String :tamf_ty, :size=>255
    end

    create_table(:complete_abrogation_regulations, :ignore_index_errors=>false) do
      Integer :complete_abrogation_regulation_role
      String :complete_abrogation_regulation_id, :size=>255
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      Integer :replacement_indicator
      String :information_text, :text=>true
      TrueClass :approved_flag
      DateTime :created_at
      DateTime :updated_at

      index [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:duty_expression_descriptions, :ignore_index_errors=>false) do
      String :duty_expression_id, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_duty_expression_descriptions_on_language_id
      index [:duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:duty_expressions, :ignore_index_errors=>false) do
      String :duty_expression_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :duty_amount_applicability_code
      Integer :measurement_unit_applicability_code
      Integer :monetary_unit_applicability_code
      DateTime :created_at
      DateTime :updated_at

      index [:duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:explicit_abrogation_regulations, :ignore_index_errors=>false) do
      Integer :explicit_abrogation_regulation_role
      String :explicit_abrogation_regulation_id, :size=>8
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      Integer :replacement_indicator
      Date :abrogation_date
      String :information_text, :text=>true
      TrueClass :approved_flag
      DateTime :created_at
      DateTime :updated_at

      index [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_description_periods, :ignore_index_errors=>false) do
      Integer :export_refund_nomenclature_description_period_sid
      Integer :export_refund_nomenclature_sid
      DateTime :validity_start_date
      String :goods_nomenclature_item_id, :size=>10
      Integer :additional_code_type
      String :export_refund_code, :size=>255
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:export_refund_nomenclature_sid, :export_refund_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_descriptions, :ignore_index_errors=>false) do
      Integer :export_refund_nomenclature_description_period_sid
      String :language_id, :size=>5
      Integer :export_refund_nomenclature_sid
      String :goods_nomenclature_item_id, :size=>10
      Integer :additional_code_type
      String :export_refund_code, :size=>255
      String :productline_suffix, :size=>2
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:export_refund_nomenclature_sid], :name=>:export_refund_nomenclature
      index [:language_id], :name=>:index_export_refund_nomenclature_descriptions_on_language_id
      index [:export_refund_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclature_indents, :ignore_index_errors=>false) do
      Integer :export_refund_nomenclature_indents_sid
      Integer :export_refund_nomenclature_sid
      DateTime :validity_start_date
      String :number_export_refund_nomenclature_indents, :size=>255
      String :goods_nomenclature_item_id, :size=>10
      Integer :additional_code_type
      String :export_refund_code, :size=>255
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:export_refund_nomenclature_indents_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:export_refund_nomenclatures, :ignore_index_errors=>false) do
      Integer :export_refund_nomenclature_sid
      String :goods_nomenclature_item_id, :size=>10
      Integer :additional_code_type
      String :export_refund_code, :size=>255
      String :productline_suffix, :size=>2
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :goods_nomenclature_sid
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_sid], :name=>:index_export_refund_nomenclatures_on_goods_nomenclature_sid
      index [:export_refund_nomenclature_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_additional_codes, :ignore_index_errors=>false) do
      Integer :additional_code_sid
      String :footnote_type_id, :size=>2
      String :footnote_id, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :additional_code_type_id
      String :additional_code, :size=>3
      DateTime :created_at
      DateTime :updated_at

      index [:additional_code_type_id], :name=>:additional_code_type
      index [:footnote_id, :footnote_type_id, :additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_erns, :ignore_index_errors=>false) do
      Integer :export_refund_nomenclature_sid
      String :footnote_type, :size=>2
      String :footnote_id, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :goods_nomenclature_item_id, :size=>10
      Integer :additional_code_type
      String :export_refund_code, :size=>255
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:export_refund_nomenclature_sid, :footnote_id, :footnote_type, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_goods_nomenclatures, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      String :footnote_type, :size=>2
      String :footnote_id, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:footnote_id, :footnote_type, :goods_nomenclature_sid, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_association_measures, :ignore_index_errors=>false) do
      Integer :measure_sid
      String :footnote_type_id, :size=>2
      String :footnote_id, :size=>3
      DateTime :created_at
      DateTime :updated_at

      index :measure_sid, :name=>:measure_sid
      index :footnote_id, :name=>:footnote_id
    end

    create_table(:footnote_association_meursing_headings, :ignore_index_errors=>false) do
      String :meursing_table_plan_id, :size=>2
      String :meursing_heading_number, :size=>255
      Integer :row_column_code
      String :footnote_type, :size=>2
      String :footnote_id, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:footnote_id, :meursing_table_plan_id], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_description_periods, :ignore_index_errors=>false) do
      Integer :footnote_description_period_sid
      String :footnote_type_id, :size=>2
      String :footnote_id, :size=>3
      DateTime :validity_start_date
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:footnote_id, :footnote_type_id, :footnote_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_descriptions, :ignore_index_errors=>false) do
      Integer :footnote_description_period_sid
      String :footnote_type_id, :size=>2
      String :footnote_id, :size=>3
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_footnote_descriptions_on_language_id
      index [:footnote_id, :footnote_type_id, :footnote_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_type_descriptions, :ignore_index_errors=>false) do
      String :footnote_type_id, :size=>2
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_footnote_type_descriptions_on_language_id
      index [:footnote_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:footnote_types, :ignore_index_errors=>false) do
      String :footnote_type_id, :size=>2
      Integer :application_code
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:footnote_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:footnotes, :ignore_index_errors=>false) do
      String :footnote_id, :size=>3
      String :footnote_type_id, :size=>2
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:footnote_id, :footnote_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:fts_regulation_actions, :ignore_index_errors=>false) do
      Integer :fts_regulation_role
      String :fts_regulation_id, :size=>8
      Integer :stopped_regulation_role
      String :stopped_regulation_id, :size=>8
      DateTime :created_at
      DateTime :updated_at

      index [:fts_regulation_id, :fts_regulation_role, :stopped_regulation_id, :stopped_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:full_temporary_stop_regulations, :ignore_index_errors=>false) do
      Integer :full_temporary_stop_regulation_role
      String :full_temporary_stop_regulation_id, :size=>8
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      DateTime :validity_start_date
      DateTime :validity_end_date
      Date :effective_enddate
      Integer :explicit_abrogation_regulation_role
      String :explicit_abrogation_regulation_id, :size=>8
      Integer :replacement_indicator
      String :information_text, :text=>true
      TrueClass :approved_flag
      DateTime :created_at
      DateTime :updated_at

      index [:explicit_abrogation_regulation_role, :explicit_abrogation_regulation_id], :name=>:explicit_abrogation_regulation
      index [:full_temporary_stop_regulation_id, :full_temporary_stop_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_description_periods, :ignore_index_errors=>false) do
      Integer :geographical_area_description_period_sid
      Integer :geographical_area_sid
      DateTime :validity_start_date
      String :geographical_area_id, :size=>255
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:geographical_area_description_period_sid, :geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_descriptions, :ignore_index_errors=>false) do
      Integer :geographical_area_description_period_sid
      String :language_id, :size=>5
      Integer :geographical_area_sid
      String :geographical_area_id, :size=>255
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_geographical_area_descriptions_on_language_id
      index [:geographical_area_description_period_sid, :geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_area_memberships, :ignore_index_errors=>false) do
      Integer :geographical_area_sid
      Integer :geographical_area_group_sid
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:geographical_area_sid, :geographical_area_group_sid, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:geographical_areas, :ignore_index_errors=>false) do
      Integer :geographical_area_sid
      Integer :parent_geographical_area_group_sid
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :geographical_code, :size=>255
      String :geographical_area_id, :size=>255
      DateTime :created_at
      DateTime :updated_at

      index [:parent_geographical_area_group_sid], :name=>:index_geographical_areas_on_parent_geographical_area_group_sid
      index [:geographical_area_sid], :name=>:primary_key, :unique=>true
      index [:geographical_area_id], :name=>:geographical_area_id, :unique=>true
    end

    create_table(:goods_nomenclature_description_periods, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_description_period_sid
      Integer :goods_nomenclature_sid
      DateTime :validity_start_date
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:goods_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
      index [:goods_nomenclature_sid, :validity_start_date, :validity_end_date], :name=>:goods_nomenclature
    end

    create_table(:goods_nomenclature_descriptions, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_description_period_sid
      String :language_id, :size=>5
      Integer :goods_nomenclature_sid
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_goods_nomenclature_descriptions_on_language_id
      index [:goods_nomenclature_sid, :goods_nomenclature_description_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_group_descriptions, :ignore_index_errors=>false) do
      String :goods_nomenclature_group_type, :size=>1
      String :goods_nomenclature_group_id, :size=>6
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_goods_nomenclature_group_descriptions_on_language_id
      index [:goods_nomenclature_group_id, :goods_nomenclature_group_type], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_groups, :ignore_index_errors=>false) do
      String :goods_nomenclature_group_type, :size=>1
      String :goods_nomenclature_group_id, :size=>6
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :nomenclature_group_facility_code
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_group_id, :goods_nomenclature_group_type], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_indents, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_indent_sid
      Integer :goods_nomenclature_sid
      DateTime :validity_start_date
      Integer :number_indents
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:goods_nomenclature_sid], :name=>:goods_nomenclature_sid
      index [:validity_start_date, :validity_end_date], :name=>:goods_nomenclature_validity_dates
      index [:goods_nomenclature_indent_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_origins, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      String :derived_goods_nomenclature_item_id, :size=>10
      String :derived_productline_suffix, :size=>2
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_sid, :derived_goods_nomenclature_item_id, :derived_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclature_successors, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      String :absorbed_goods_nomenclature_item_id, :size=>10
      String :absorbed_productline_suffix, :size=>2
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_sid, :absorbed_goods_nomenclature_item_id, :absorbed_productline_suffix, :goods_nomenclature_item_id, :productline_suffix], :name=>:primary_key, :unique=>true
    end

    create_table(:goods_nomenclatures, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      String :goods_nomenclature_item_id, :size=>10
      String :producline_suffix, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :statistical_indicator
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_item_id, :producline_suffix], :name=>:item_id
      index [:goods_nomenclature_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:language_descriptions, :ignore_index_errors=>false) do
      String :language_code_id, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id, :language_code_id], :name=>:primary_key, :unique=>true
    end

    create_table(:languages, :ignore_index_errors=>false) do
      String :language_id, :size=>5
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_action_descriptions, :ignore_index_errors=>false) do
      String :action_code, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:action_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_actions, :ignore_index_errors=>false) do
      String :action_code, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:action_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_components, :ignore_index_errors=>false) do
      Integer :measure_sid
      String :duty_expression_id, :size=>255
      Integer :duty_amount
      String :monetary_unit_code, :size=>255
      String :measurement_unit_code, :size=>3
      String :measurement_unit_qualifier_code, :size=>1
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_code], :name=>:index_measure_components_on_measurement_unit_code
      index [:measurement_unit_qualifier_code], :name=>:index_measure_components_on_measurement_unit_qualifier_code
      index [:monetary_unit_code], :name=>:index_measure_components_on_monetary_unit_code
      index [:measure_sid, :duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_code_descriptions, :ignore_index_errors=>false) do
      String :condition_code, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:condition_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_codes, :ignore_index_errors=>false) do
      String :condition_code, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:condition_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_condition_components, :ignore_index_errors=>false) do
      Integer :measure_condition_sid
      String :duty_expression_id, :size=>255
      Integer :duty_amount
      String :monetary_unit_code, :size=>255
      String :measurement_unit_code, :size=>3
      String :measurement_unit_qualifier_code, :size=>1
      DateTime :created_at
      DateTime :updated_at

      index [:duty_expression_id], :name=>:index_measure_condition_components_on_duty_expression_id
      index [:measurement_unit_code], :name=>:index_measure_condition_components_on_measurement_unit_code
      index [:monetary_unit_code], :name=>:index_measure_condition_components_on_monetary_unit_code
      index [:measurement_unit_qualifier_code], :name=>:measurement_unit_qualifier_code
      index [:measure_condition_sid, :duty_expression_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_conditions, :ignore_index_errors=>false) do
      Integer :measure_condition_sid
      Integer :measure_sid
      String :condition_code, :size=>255
      Integer :component_sequence_number
      Integer :condition_duty_amount
      String :condition_monetary_unit_code, :size=>255
      String :condition_measurement_unit_code, :size=>3
      String :condition_measurement_unit_qualifier_code, :size=>1
      String :action_code, :size=>255
      String :certificate_type_code, :size=>1
      String :certificate_code, :size=>3
      DateTime :created_at
      DateTime :updated_at

      index [:certificate_code, :certificate_type_code], :name=>:certificate
      index [:condition_measurement_unit_qualifier_code], :name=>:condition_measurement_unit_qualifier_code
      index [:action_code], :name=>:index_measure_conditions_on_action_code
      index [:condition_measurement_unit_code], :name=>:index_measure_conditions_on_condition_measurement_unit_code
      index [:condition_monetary_unit_code], :name=>:index_measure_conditions_on_condition_monetary_unit_code
      index [:measure_sid], :name=>:index_measure_conditions_on_measure_sid
      index [:measure_condition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_excluded_geographical_areas, :ignore_index_errors=>false) do
      Integer :measure_sid
      String :excluded_geographical_area, :size=>255
      Integer :geographical_area_sid
      DateTime :created_at
      DateTime :updated_at

      index [:measure_sid, :excluded_geographical_area, :geographical_area_sid], :name=>:primary_key, :unique=>true
      index :geographical_area_sid, :name=>:geographical_area_sid
    end

    create_table(:measure_partial_temporary_stops, :ignore_index_errors=>false) do
      Integer :measure_sid
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :partial_temporary_stop_regulation_id, :size=>255
      String :partial_temporary_stop_regulation_officialjournal_number, :size=>255
      Integer :partial_temporary_stop_regulation_officialjournal_page
      String :abrogation_regulation_id, :size=>255
      String :abrogation_regulation_officialjournal_number, :size=>255
      Integer :abrogation_regulation_officialjournal_page
      DateTime :created_at
      DateTime :updated_at

      index [:abrogation_regulation_id], :name=>:abrogation_regulation_id
      index [:measure_sid, :partial_temporary_stop_regulation_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_descriptions, :ignore_index_errors=>false) do
      Integer :measure_type_id
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_measure_type_descriptions_on_language_id
      index [:measure_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_series, :ignore_index_errors=>false) do
      String :measure_type_series_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :measure_type_combination
      DateTime :created_at
      DateTime :updated_at

      index [:measure_type_series_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_type_series_descriptions, :ignore_index_errors=>false) do
      String :measure_type_series_id, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_measure_type_series_descriptions_on_language_id
      index [:measure_type_series_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measure_types, :ignore_index_errors=>false) do
      Integer :measure_type_id
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :trade_movement_code
      Integer :priority_code
      Integer :measure_component_applicable_code
      Integer :origin_dest_code
      Integer :order_number_capture_code
      Integer :measure_explosion_level
      String :measure_type_series_id, :size=>255
      DateTime :created_at
      DateTime :updated_at

      index [:measure_type_series_id], :name=>:index_measure_types_on_measure_type_series_id
      index [:measure_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_descriptions, :ignore_index_errors=>false) do
      String :measurement_unit_code, :size=>3
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_measurement_unit_descriptions_on_language_id
      index [:measurement_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_qualifier_descriptions, :ignore_index_errors=>false) do
      String :measurement_unit_qualifier_code, :size=>1
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_unit_qualifiers, :ignore_index_errors=>false) do
      String :measurement_unit_qualifier_code, :size=>1
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurement_units, :ignore_index_errors=>false) do
      String :measurement_unit_code, :size=>3
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measurements, :ignore_index_errors=>false) do
      String :measurement_unit_code, :size=>3
      String :measurement_unit_qualifier_code, :size=>1
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_code, :measurement_unit_qualifier_code], :name=>:primary_key, :unique=>true
    end

    create_table(:measures, :ignore_index_errors=>false) do
      Integer :measure_sid
      Integer :measure_type
      String :geographical_area, :size=>255
      String :goods_nomenclature_item_id, :size=>10
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :measure_generating_regulation_role
      String :measure_generating_regulation_id, :size=>255
      Integer :justification_regulation_role
      String :justification_regulation_id, :size=>255
      TrueClass :stopped_flag
      Integer :geographical_area_sid
      Integer :goods_nomenclature_sid
      String :ordernumber, :size=>255
      Integer :additional_code_type
      String :additional_code, :size=>3
      Integer :additional_code_sid
      Integer :reduction_indicator
      Integer :export_refund_nomenclature_sid
      DateTime :created_at
      DateTime :updated_at

      index [:additional_code_sid], :name=>:index_measures_on_additional_code_sid
      index [:geographical_area_sid], :name=>:index_measures_on_geographical_area_sid
      index [:goods_nomenclature_sid], :name=>:index_measures_on_goods_nomenclature_sid
      index [:measure_type], :name=>:index_measures_on_measure_type
      index [:justification_regulation_role, :justification_regulation_id], :name=>:justification_regulation
      index :measure_generating_regulation_id, :name=>:measure_generating_regulation
      index [:measure_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_additional_codes, :ignore_index_errors=>false) do
      Integer :meursing_additional_code_sid
      Integer :additional_code
      DateTime :validity_start_date
      DateTime :created_at
      DateTime :updated_at
      DateTime :validity_end_date

      index [:meursing_additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_heading_texts, :ignore_index_errors=>false) do
      String :meursing_table_plan_id, :size=>2
      Integer :meursing_heading_number
      Integer :row_column_code
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_headings, :ignore_index_errors=>false) do
      String :meursing_table_plan_id, :size=>2
      Integer :meursing_heading_number
      Integer :row_column_code
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_subheadings, :ignore_index_errors=>false) do
      String :meursing_table_plan_id, :size=>2
      Integer :meursing_heading_number
      Integer :row_column_code
      Integer :subheading_sequence_number
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id, :meursing_heading_number, :row_column_code, :subheading_sequence_number], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_table_cell_components, :ignore_index_errors=>false) do
      Integer :meursing_additional_code_sid
      String :meursing_table_plan_id, :size=>2
      Integer :heading_number
      Integer :row_column_code
      Integer :subheading_sequence_number
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :additional_code
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id, :heading_number, :row_column_code, :meursing_additional_code_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:meursing_table_plans, :ignore_index_errors=>false) do
      String :meursing_table_plan_id, :size=>2
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:meursing_table_plan_id], :name=>:primary_key, :unique=>true
    end

    create_table(:modification_regulations, :ignore_index_errors=>false) do
      Integer :modification_regulation_role
      String :modification_regulation_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      Integer :base_regulation_role
      String :base_regulation_id, :size=>255
      Integer :replacement_indicator
      TrueClass :stopped_flag
      String :information_text, :text=>true
      TrueClass :approved_flag
      Integer :explicit_abrogation_regulation_role
      String :explicit_abrogation_regulation_id, :size=>8
      Date :effective_end_date
      Integer :complete_abrogation_regulation_role
      String :complete_abrogation_regulation_id, :size=>8
      DateTime :created_at
      DateTime :updated_at

      index [:base_regulation_id, :base_regulation_role], :name=>:base_regulation
      index [:complete_abrogation_regulation_id, :complete_abrogation_regulation_role], :name=>:complete_abrogation_regulation
      index [:explicit_abrogation_regulation_id, :explicit_abrogation_regulation_role], :name=>:explicit_abrogation_regulation
      index [:modification_regulation_id, :modification_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_exchange_periods, :ignore_index_errors=>false) do
      Integer :monetary_exchange_period_sid
      String :parent_monetary_unit_code, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:monetary_exchange_period_sid, :parent_monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_exchange_rates, :ignore_index_errors=>false) do
      Integer :monetary_exchange_period_sid
      String :child_monetary_unit_code, :size=>255
      BigDecimal :exchange_rate, :size=>[16, 8]
      DateTime :created_at
      DateTime :updated_at

      index [:monetary_exchange_period_sid, :child_monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_unit_descriptions, :ignore_index_errors=>false) do
      String :monetary_unit_code, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_monetary_unit_descriptions_on_language_id
      index [:monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:monetary_units, :ignore_index_errors=>false) do
      String :monetary_unit_code, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:monetary_unit_code], :name=>:primary_key, :unique=>true
    end

    create_table(:nomenclature_group_memberships, :ignore_index_errors=>false) do
      Integer :goods_nomenclature_sid
      String :goods_nomenclature_group_type, :size=>1
      String :goods_nomenclature_group_id, :size=>6
      DateTime :validity_start_date
      DateTime :validity_end_date
      String :goods_nomenclature_item_id, :size=>10
      String :productline_suffix, :size=>2
      DateTime :created_at
      DateTime :updated_at

      index [:goods_nomenclature_sid, :goods_nomenclature_group_id, :goods_nomenclature_group_type, :goods_nomenclature_item_id, :validity_start_date], :name=>:primary_key, :unique=>true
    end

    create_table(:prorogation_regulation_actions, :ignore_index_errors=>false) do
      Integer :prorogation_regulation_role
      String :prorogation_regulation_id, :size=>8
      Integer :prorogated_regulation_role
      String :prorogated_regulation_id, :size=>8
      Date :prorogated_date
      DateTime :created_at
      DateTime :updated_at

      index [:prorogation_regulation_id, :prorogation_regulation_role, :prorogated_regulation_id, :prorogated_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:prorogation_regulations, :ignore_index_errors=>false) do
      Integer :prorogation_regulation_role
      String :prorogation_regulation_id, :size=>255
      Date :published_date
      String :officialjournal_number, :size=>255
      Integer :officialjournal_page
      Integer :replacement_indicator
      String :information_text, :text=>true
      TrueClass :approved_flag
      DateTime :created_at
      DateTime :updated_at

      index [:prorogation_regulation_id, :prorogation_regulation_role], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_associations, :ignore_index_errors=>false) do
      Integer :main_quota_definition_sid
      Integer :sub_quota_definition_sid
      String :relation_type, :size=>255
      BigDecimal :coefficient, :size=>[16, 5]
      DateTime :created_at
      DateTime :updated_at

      index [:main_quota_definition_sid, :sub_quota_definition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_balance_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      Date :last_import_date_in_allocation
      Integer :old_balance
      Integer :new_balance
      Integer :imported_amount
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_blocking_periods, :ignore_index_errors=>false) do
      Integer :quota_blocking_period_sid
      Integer :quota_definition_sid
      Date :blocking_start_date
      Date :blocking_end_date
      Integer :blocking_period_type
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:quota_blocking_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_critical_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      String :critical_state, :size=>255
      Date :critical_state_change_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_definitions, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      String :quota_order_number_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :quota_order_number_sid
      Integer :volume
      Integer :initial_volume
      String :measurement_unit_code, :size=>3
      Integer :maximum_precision
      String :critical_state, :size=>255
      Integer :critical_threshold
      String :monetary_unit_code, :size=>255
      String :measurement_unit_qualifier_code, :size=>1
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:measurement_unit_code], :name=>:index_quota_definitions_on_measurement_unit_code
      index [:measurement_unit_qualifier_code], :name=>:index_quota_definitions_on_measurement_unit_qualifier_code
      index [:monetary_unit_code], :name=>:index_quota_definitions_on_monetary_unit_code
      index [:quota_order_number_id], :name=>:index_quota_definitions_on_quota_order_number_id
      index [:quota_definition_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_exhaustion_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      Date :exhaustion_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_number_origin_exclusions, :ignore_index_errors=>false) do
      Integer :quota_order_number_origin_sid
      Integer :excluded_geographical_area_sid
      DateTime :created_at
      DateTime :updated_at

      index [:quota_order_number_origin_sid, :excluded_geographical_area_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_number_origins, :ignore_index_errors=>false) do
      Integer :quota_order_number_origin_sid
      Integer :quota_order_number_sid
      String :geographical_area_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      Integer :geographical_area_sid
      DateTime :created_at
      DateTime :updated_at

      index [:geographical_area_sid], :name=>:index_quota_order_number_origins_on_geographical_area_sid
      index [:quota_order_number_origin_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_order_numbers, :ignore_index_errors=>false) do
      Integer :quota_order_number_sid
      String :quota_order_number_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_order_number_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_reopening_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      Date :reopening_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_suspension_periods, :ignore_index_errors=>false) do
      Integer :quota_suspension_period_sid
      Integer :quota_definition_sid
      Date :suspension_start_date
      Date :suspension_end_date
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid], :name=>:index_quota_suspension_periods_on_quota_definition_sid
      index [:quota_suspension_period_sid], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_unblocking_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      Date :unblocking_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:quota_unsuspension_events, :ignore_index_errors=>false) do
      Integer :quota_definition_sid
      DateTime :occurrence_timestamp
      Date :unsuspension_date
      DateTime :created_at
      DateTime :updated_at

      index [:quota_definition_sid, :occurrence_timestamp], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_group_descriptions, :ignore_index_errors=>false) do
      String :regulation_group_id, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_regulation_group_descriptions_on_language_id
      index [:regulation_group_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_groups, :ignore_index_errors=>false) do
      String :regulation_group_id, :size=>255
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:regulation_group_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_replacements, :ignore_index_errors=>false) do
      String :geographical_area_id, :size=>255
      String :chapter_heading, :size=>255
      Integer :replacing_regulation_role
      String :replacing_regulation_id, :size=>255
      Integer :replaced_regulation_role
      String :replaced_regulation_id, :size=>255
      Integer :measure_type_id
      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:regulation_role_type_descriptions, :ignore_index_errors=>false) do
      String :regulation_role_type_id, :size=>255
      String :language_id, :size=>5
      String :description, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:language_id], :name=>:index_regulation_role_type_descriptions_on_language_id
      index [:regulation_role_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:regulation_role_types, :ignore_index_errors=>false) do
      Integer :regulation_role_type_id
      DateTime :validity_start_date
      DateTime :validity_end_date
      DateTime :created_at
      DateTime :updated_at

      index [:regulation_role_type_id], :name=>:primary_key, :unique=>true
    end

    create_table(:sections) do
      primary_key :id
      Integer :position
      String :numeral, :size=>255
      String :title, :size=>255
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
    end

    create_table(:transmission_comments, :ignore_index_errors=>false) do
      Integer :comment_sid
      String :language_id, :size=>5
      String :comment_text, :text=>true
      DateTime :created_at
      DateTime :updated_at

      index [:comment_sid, :language_id], :name=>:primary_key, :unique=>true
    end
  end
end
