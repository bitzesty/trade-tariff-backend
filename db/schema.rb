# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120710160550) do

  create_table "additional_code_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_description_period_sid"
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "additional_code_description_periods", ["additional_code_description_period_sid", "additional_code_sid", "additional_code_type_id"], :name => "primary_key", :unique => true
  add_index "additional_code_description_periods", ["additional_code_description_period_sid"], :name => "description_period_sid"
  add_index "additional_code_description_periods", ["additional_code_type_id"], :name => "code_type_id"

  create_table "additional_code_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_description_period_sid"
    t.string   "language_id"
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "additional_code_descriptions", ["additional_code_description_period_sid", "additional_code_sid"], :name => "primary_key", :unique => true
  add_index "additional_code_descriptions", ["additional_code_description_period_sid"], :name => "period_sid"
  add_index "additional_code_descriptions", ["additional_code_sid"], :name => "sid"
  add_index "additional_code_descriptions", ["additional_code_type_id"], :name => "type_id"
  add_index "additional_code_descriptions", ["language_id"], :name => "language_id"

  create_table "additional_code_type_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "additional_code_type_descriptions", ["additional_code_type_id"], :name => "primary_key", :unique => true
  add_index "additional_code_type_descriptions", ["language_id"], :name => "index_additional_code_type_descriptions_on_language_id"

  create_table "additional_code_type_measure_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measure_type_id"
    t.string   "additional_code_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "additional_code_type_measure_types", ["measure_type_id", "additional_code_type_id"], :name => "primary_key", :unique => true

  create_table "additional_code_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "application_code"
    t.string   "meursing_table_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "additional_code_types", ["additional_code_type_id"], :name => "primary_key", :unique => true
  add_index "additional_code_types", ["meursing_table_plan_id"], :name => "index_additional_code_types_on_meursing_table_plan_id"

  create_table "additional_codes", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "additional_codes", ["additional_code_sid"], :name => "primary_key", :unique => true
  add_index "additional_codes", ["additional_code_type_id"], :name => "type_id"

  create_table "base_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "base_regulation_role"
    t.string   "base_regulation_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "community_code"
    t.string   "regulation_group_id"
    t.integer  "replacement_indicator"
    t.boolean  "stopped_flag"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.date     "effective_end_date"
    t.integer  "antidumping_regulation_role"
    t.string   "related_antidumping_regulation_id"
    t.integer  "complete_abrogation_regulation_role"
    t.string   "complete_abrogation_regulation_id"
    t.integer  "explicit_abrogation_regulation_role"
    t.string   "explicit_abrogation_regulation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "base_regulations", ["antidumping_regulation_role", "related_antidumping_regulation_id"], :name => "antidumping_regulation"
  add_index "base_regulations", ["base_regulation_id", "base_regulation_role"], :name => "primary_key", :unique => true
  add_index "base_regulations", ["complete_abrogation_regulation_role", "complete_abrogation_regulation_id"], :name => "complete_abrogation_regulation"
  add_index "base_regulations", ["explicit_abrogation_regulation_role", "explicit_abrogation_regulation_id"], :name => "explicit_abrogation_regulation"
  add_index "base_regulations", ["regulation_group_id"], :name => "index_base_regulations_on_regulation_group_id"

  create_table "certificate_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "certificate_description_period_sid"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "certificate_description_periods", ["certificate_code", "certificate_type_code"], :name => "certificate"
  add_index "certificate_description_periods", ["certificate_description_period_sid"], :name => "primary_key", :unique => true

  create_table "certificate_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "certificate_description_period_sid"
    t.string   "language_id"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "certificate_descriptions", ["certificate_code", "certificate_type_code"], :name => "certificate"
  add_index "certificate_descriptions", ["certificate_description_period_sid"], :name => "primary_key", :unique => true
  add_index "certificate_descriptions", ["language_id"], :name => "index_certificate_descriptions_on_language_id"

  create_table "certificate_type_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "certificate_type_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "certificate_type_descriptions", ["certificate_type_code"], :name => "primary_key", :unique => true
  add_index "certificate_type_descriptions", ["language_id"], :name => "index_certificate_type_descriptions_on_language_id"

  create_table "certificate_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "certificate_type_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "certificate_types", ["certificate_type_code"], :name => "primary_key", :unique => true

  create_table "certificates", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comm", :id => false, :force => true do |t|
    t.datetime "fe_tsmp"
    t.string   "cmdty_code"
    t.datetime "le_tsmp"
    t.string   "add_rlf_alwd_ind"
    t.string   "alcohol_cmdty"
    t.datetime "audit_tsmp"
    t.string   "chi_doti_rqd"
    t.string   "cmdty_bbeer"
    t.string   "cmdty_beer"
    t.string   "cmdty_euse_rfnd"
    t.string   "cmdty_mdecln"
    t.string   "exp_lcnc_rqd"
    t.string   "ex_ec_scode_rqd"
    t.decimal  "full_dty_adval1",  :precision => 3, :scale => 3
    t.decimal  "full_dty_adval2",  :precision => 3, :scale => 3
    t.string   "full_dty_exch"
    t.decimal  "full_dty_spfc1",   :precision => 7, :scale => 4
    t.decimal  "full_dty_spfc2",   :precision => 7, :scale => 4
    t.string   "full_dty_ttype"
    t.string   "full_dty_uoq_c2"
    t.string   "full_dty_uoq1"
    t.string   "full_dty_uoq2"
    t.string   "full_duty_type"
    t.string   "im_ec_scode_rqd"
    t.string   "imp_exp_use"
    t.string   "nba_id"
    t.string   "perfume_cmdty"
    t.text     "rfa"
    t.integer  "season_end"
    t.integer  "season_start"
    t.string   "spv_code"
    t.string   "spv_xhdg"
    t.string   "uoq_code_cdu1"
    t.string   "uoq_code_cdu2"
    t.string   "uoq_code_cdu3"
    t.string   "whse_cmdty"
    t.string   "wines_cmdty"
  end

<<<<<<< HEAD
>>>>>>> comm table
=======
>>>>>>> schema update
  create_table "complete_abrogation_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "complete_abrogation_regulation_role"
    t.string   "complete_abrogation_regulation_id"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.integer  "replacement_indicator"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "complete_abrogation_regulations", ["complete_abrogation_regulation_id", "complete_abrogation_regulation_role"], :name => "primary_key", :unique => true

  create_table "duty_expression_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "duty_expression_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "duty_expression_descriptions", ["duty_expression_id"], :name => "primary_key", :unique => true
  add_index "duty_expression_descriptions", ["language_id"], :name => "index_duty_expression_descriptions_on_language_id"

  create_table "duty_expressions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "duty_expression_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "duty_amount_applicability_code"
    t.integer  "measurement_unit_applicability_code"
    t.integer  "monetary_unit_applicability_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "duty_expressions", ["duty_expression_id"], :name => "primary_key", :unique => true

  create_table "explicit_abrogation_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "explicit_abrogation_regulation_role"
    t.string   "explicit_abrogation_regulation_id"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.integer  "replacement_indicator"
    t.date     "abrogation_date"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "explicit_abrogation_regulations", ["explicit_abrogation_regulation_id", "explicit_abrogation_regulation_role"], :name => "primary_key", :unique => true

  create_table "export_refund_nomenclature_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "export_refund_nomenclature_description_period_sid"
    t.string   "export_refund_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "export_refund_nomenclature_description_periods", ["export_refund_nomenclature_sid", "export_refund_nomenclature_description_period_sid"], :name => "primary_key", :unique => true

  create_table "export_refund_nomenclature_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "export_refund_nomenclature_description_period_sid"
    t.string   "language_id"
    t.string   "export_refund_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "export_refund_nomenclature_descriptions", ["export_refund_nomenclature_description_period_sid"], :name => "primary_key", :unique => true
  add_index "export_refund_nomenclature_descriptions", ["export_refund_nomenclature_sid"], :name => "export_refund_nomenclature"
  add_index "export_refund_nomenclature_descriptions", ["language_id"], :name => "index_export_refund_nomenclature_descriptions_on_language_id"

  create_table "export_refund_nomenclature_indents", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "export_refund_nomenclature_indents_sid"
    t.string   "export_refund_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "number_export_refund_nomenclature_indents"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "export_refund_nomenclature_indents", ["export_refund_nomenclature_indents_sid"], :name => "primary_key", :unique => true

  create_table "export_refund_nomenclatures", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "export_refund_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "goods_nomenclature_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "export_refund_nomenclatures", ["export_refund_nomenclature_sid"], :name => "primary_key", :unique => true
  add_index "export_refund_nomenclatures", ["goods_nomenclature_sid"], :name => "index_export_refund_nomenclatures_on_goods_nomenclature_sid"

  create_table "footnote_association_additional_codes", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "additional_code_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "additional_code_type_id"
    t.string   "additional_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_association_additional_codes", ["additional_code_type_id"], :name => "additional_code_type"
  add_index "footnote_association_additional_codes", ["footnote_id", "footnote_type_id", "additional_code_sid"], :name => "primary_key", :unique => true

  create_table "footnote_association_erns", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "export_refund_nomenclature_sid"
    t.string   "footnote_type"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_association_erns", ["export_refund_nomenclature_sid", "footnote_id", "footnote_type", "validity_start_date"], :name => "primary_key", :unique => true

  create_table "footnote_association_goods_nomenclatures", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "goods_nomenclature_sid"
    t.string   "footnote_type"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_association_goods_nomenclatures", ["footnote_id", "footnote_type", "goods_nomenclature_sid", "validity_start_date"], :name => "primary_key", :unique => true

  create_table "footnote_association_measures", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measure_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_association_measures", ["measure_sid", "footnote_id", "footnote_type_id"], :name => "primary_key", :unique => true

  create_table "footnote_association_meursing_headings", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "meursing_table_plan_id"
    t.string   "meursing_heading_number"
    t.integer  "row_column_code"
    t.string   "footnote_type"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_association_meursing_headings", ["footnote_id", "meursing_table_plan_id"], :name => "primary_key", :unique => true

  create_table "footnote_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "footnote_description_period_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "footnote_description_periods", ["footnote_id", "footnote_type_id", "footnote_description_period_sid"], :name => "primary_key", :unique => true

  create_table "footnote_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "footnote_description_period_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_descriptions", ["footnote_id", "footnote_type_id", "footnote_description_period_sid"], :name => "primary_key", :unique => true
  add_index "footnote_descriptions", ["language_id"], :name => "index_footnote_descriptions_on_language_id"

  create_table "footnote_type_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "footnote_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_type_descriptions", ["footnote_type_id"], :name => "primary_key", :unique => true
  add_index "footnote_type_descriptions", ["language_id"], :name => "index_footnote_type_descriptions_on_language_id"

  create_table "footnote_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "footnote_type_id"
    t.integer  "application_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnote_types", ["footnote_type_id"], :name => "primary_key", :unique => true

  create_table "footnotes", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "footnote_id"
    t.string   "footnote_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "footnotes", ["footnote_id", "footnote_type_id"], :name => "primary_key", :unique => true

  create_table "fts_regulation_actions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "fts_regulation_role"
    t.string   "fts_regulation_id"
    t.integer  "stopped_regulation_role"
    t.string   "stopped_regulation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fts_regulation_actions", ["fts_regulation_id", "fts_regulation_role", "stopped_regulation_id", "stopped_regulation_role"], :name => "primary_key", :unique => true

  create_table "full_temporary_stop_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "full_temporary_stop_regulation_role"
    t.string   "full_temporary_stop_regulation_id"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.date     "effective_enddate"
    t.integer  "explicit_abrogation_regulation_role"
    t.string   "explicit_abrogation_regulation_id"
    t.integer  "replacement_indicator"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "full_temporary_stop_regulations", ["explicit_abrogation_regulation_role", "explicit_abrogation_regulation_id"], :name => "explicit_abrogation_regulation"
  add_index "full_temporary_stop_regulations", ["full_temporary_stop_regulation_id", "full_temporary_stop_regulation_role"], :name => "primary_key", :unique => true

  create_table "geographical_area_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "geographical_area_description_period_sid"
    t.integer  "geographical_area_sid"
    t.date     "validity_start_date"
    t.string   "geographical_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "geographical_area_description_periods", ["geographical_area_description_period_sid", "geographical_area_sid"], :name => "primary_key", :unique => true

  create_table "geographical_area_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "geographical_area_description_period_sid"
    t.string   "language_id"
    t.integer  "geographical_area_sid"
    t.string   "geographical_area_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geographical_area_descriptions", ["geographical_area_description_period_sid", "geographical_area_sid"], :name => "primary_key", :unique => true
  add_index "geographical_area_descriptions", ["language_id"], :name => "index_geographical_area_descriptions_on_language_id"

  create_table "geographical_area_memberships", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "geographical_area_sid"
    t.integer  "geographical_area_group_sid"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geographical_area_memberships", ["geographical_area_sid", "geographical_area_group_sid", "validity_start_date"], :name => "primary_key", :unique => true

  create_table "geographical_areas", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "geographical_area_sid"
    t.integer  "parent_geographical_area_group_sid"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "geographical_code"
    t.string   "geographical_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geographical_areas", ["geographical_area_sid"], :name => "primary_key", :unique => true
  add_index "geographical_areas", ["parent_geographical_area_group_sid"], :name => "index_geographical_areas_on_parent_geographical_area_group_sid"

  create_table "goods_nomenclature_description_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_description_period_sid"
    t.integer  "goods_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "goods_nomenclature_description_periods", ["goods_nomenclature_description_period_sid"], :name => "primary_key", :unique => true

  create_table "goods_nomenclature_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_description_period_sid"
    t.string   "language_id"
    t.integer  "goods_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclature_descriptions", ["goods_nomenclature_sid", "goods_nomenclature_description_period_sid"], :name => "primary_key", :unique => true
  add_index "goods_nomenclature_descriptions", ["language_id"], :name => "index_goods_nomenclature_descriptions_on_language_id"

  create_table "goods_nomenclature_group_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "goods_nomenclature_group_type"
    t.string   "goods_nomenclature_group_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclature_group_descriptions", ["goods_nomenclature_group_id", "goods_nomenclature_group_type"], :name => "primary_key", :unique => true
  add_index "goods_nomenclature_group_descriptions", ["language_id"], :name => "index_goods_nomenclature_group_descriptions_on_language_id"

  create_table "goods_nomenclature_groups", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "goods_nomenclature_group_type"
    t.string   "goods_nomenclature_group_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "nomenclature_group_facility_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclature_groups", ["goods_nomenclature_group_id", "goods_nomenclature_group_type"], :name => "primary_key", :unique => true

  create_table "goods_nomenclature_indents", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_indent_sid"
    t.integer  "goods_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "number_indents"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "goods_nomenclature_indents", ["goods_nomenclature_indent_sid"], :name => "primary_key", :unique => true

  create_table "goods_nomenclature_origins", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_sid"
    t.string   "derived_goods_nomenclature_item_id"
    t.string   "derived_productline_suffix"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclature_origins", ["goods_nomenclature_sid", "derived_goods_nomenclature_item_id", "derived_productline_suffix", "goods_nomenclature_item_id", "productline_suffix"], :name => "primary_key", :unique => true

  create_table "goods_nomenclature_successors", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_sid"
    t.string   "absorbed_goods_nomenclature_item_id"
    t.string   "absorbed_productline_suffix"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclature_successors", ["goods_nomenclature_sid", "absorbed_goods_nomenclature_item_id", "absorbed_productline_suffix", "goods_nomenclature_item_id", "productline_suffix"], :name => "primary_key", :unique => true

  create_table "goods_nomenclatures", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.string   "producline_suffix"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "statistical_indicator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goods_nomenclatures", ["goods_nomenclature_sid"], :name => "primary_key", :unique => true

  create_table "language_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "language_code_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_descriptions", ["language_id", "language_code_id"], :name => "primary_key", :unique => true

  create_table "languages", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "language_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["language_id"], :name => "primary_key", :unique => true

  create_table "measure_action_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "action_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_action_descriptions", ["action_code"], :name => "primary_key", :unique => true

  create_table "measure_actions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "action_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_actions", ["action_code"], :name => "primary_key", :unique => true

  create_table "measure_components", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_sid"
    t.string   "duty_expression_id"
    t.integer  "duty_amount"
    t.string   "monetary_unit_code"
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_components", ["measure_sid", "duty_expression_id"], :name => "primary_key", :unique => true
  add_index "measure_components", ["measurement_unit_code"], :name => "index_measure_components_on_measurement_unit_code"
  add_index "measure_components", ["measurement_unit_qualifier_code"], :name => "index_measure_components_on_measurement_unit_qualifier_code"
  add_index "measure_components", ["monetary_unit_code"], :name => "index_measure_components_on_monetary_unit_code"

  create_table "measure_condition_code_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "condition_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_condition_code_descriptions", ["condition_code"], :name => "primary_key", :unique => true

  create_table "measure_condition_codes", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "condition_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_condition_codes", ["condition_code"], :name => "primary_key", :unique => true

  create_table "measure_condition_components", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_condition_sid"
    t.string   "duty_expression_id"
    t.integer  "duty_amount"
    t.string   "monetary_unit_code"
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_condition_components", ["duty_expression_id"], :name => "index_measure_condition_components_on_duty_expression_id"
  add_index "measure_condition_components", ["measure_condition_sid", "duty_expression_id"], :name => "primary_key", :unique => true
  add_index "measure_condition_components", ["measurement_unit_code"], :name => "index_measure_condition_components_on_measurement_unit_code"
  add_index "measure_condition_components", ["measurement_unit_qualifier_code"], :name => "measurement_unit_qualifier_code"
  add_index "measure_condition_components", ["monetary_unit_code"], :name => "index_measure_condition_components_on_monetary_unit_code"

  create_table "measure_conditions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_condition_sid"
    t.integer  "measure_sid"
    t.string   "condition_code"
    t.integer  "component_sequence_number"
    t.integer  "condition_duty_amount"
    t.string   "condition_monetary_unit_code"
    t.string   "condition_measurement_unit_code"
    t.string   "condition_measurement_unit_qualifier_code"
    t.string   "action_code"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_conditions", ["action_code"], :name => "index_measure_conditions_on_action_code"
  add_index "measure_conditions", ["certificate_code", "certificate_type_code"], :name => "certificate"
  add_index "measure_conditions", ["condition_measurement_unit_code"], :name => "index_measure_conditions_on_condition_measurement_unit_code"
  add_index "measure_conditions", ["condition_measurement_unit_qualifier_code"], :name => "condition_measurement_unit_qualifier_code"
  add_index "measure_conditions", ["condition_monetary_unit_code"], :name => "index_measure_conditions_on_condition_monetary_unit_code"
  add_index "measure_conditions", ["measure_condition_sid"], :name => "primary_key", :unique => true
  add_index "measure_conditions", ["measure_sid"], :name => "index_measure_conditions_on_measure_sid"

  create_table "measure_excluded_geographical_areas", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_sid"
    t.string   "excluded_geographical_area"
    t.integer  "geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_excluded_geographical_areas", ["measure_sid", "geographical_area_sid"], :name => "primary_key", :unique => true

  create_table "measure_partial_temporary_stops", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_sid"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "partial_temporary_stop_regulation_id"
    t.string   "partial_temporary_stop_regulation_officialjournal_number"
    t.integer  "partial_temporary_stop_regulation_officialjournal_page"
    t.string   "abrogation_regulation_id"
    t.string   "abrogation_regulation_officialjournal_number"
    t.integer  "abrogation_regulation_officialjournal_page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_partial_temporary_stops", ["abrogation_regulation_id"], :name => "abrogation_regulation_id"
  add_index "measure_partial_temporary_stops", ["measure_sid", "partial_temporary_stop_regulation_id"], :name => "primary_key", :unique => true

  create_table "measure_type_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_type_descriptions", ["language_id"], :name => "index_measure_type_descriptions_on_language_id"
  add_index "measure_type_descriptions", ["measure_type_id"], :name => "primary_key", :unique => true

  create_table "measure_type_series", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measure_type_series_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "measure_type_combination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_type_series", ["measure_type_series_id"], :name => "primary_key", :unique => true

  create_table "measure_type_series_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measure_type_series_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_type_series_descriptions", ["language_id"], :name => "index_measure_type_series_descriptions_on_language_id"
  add_index "measure_type_series_descriptions", ["measure_type_series_id"], :name => "primary_key", :unique => true

  create_table "measure_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "trade_movement_code"
    t.integer  "priority_code"
    t.integer  "measure_component_applicable_code"
    t.integer  "origin_dest_code"
    t.integer  "order_number_capture_code"
    t.integer  "measure_explosion_level"
    t.string   "measure_type_series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measure_types", ["measure_type_id"], :name => "primary_key", :unique => true
  add_index "measure_types", ["measure_type_series_id"], :name => "index_measure_types_on_measure_type_series_id"

  create_table "measurement_unit_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measurement_unit_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_unit_descriptions", ["language_id"], :name => "index_measurement_unit_descriptions_on_language_id"
  add_index "measurement_unit_descriptions", ["measurement_unit_code"], :name => "primary_key", :unique => true

  create_table "measurement_unit_qualifier_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measurement_unit_qualifier_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_unit_qualifier_descriptions", ["measurement_unit_qualifier_code"], :name => "primary_key", :unique => true

  create_table "measurement_unit_qualifiers", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measurement_unit_qualifier_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_unit_qualifiers", ["measurement_unit_qualifier_code"], :name => "primary_key", :unique => true

  create_table "measurement_units", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measurement_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurement_units", ["measurement_unit_code"], :name => "primary_key", :unique => true

  create_table "measurements", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurements", ["measurement_unit_code", "measurement_unit_qualifier_code"], :name => "primary_key", :unique => true

  create_table "measures", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "measure_sid"
    t.integer  "measure_type"
    t.string   "geographical_area"
    t.string   "goods_nomenclature_item_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "measure_generating_regulation_role"
    t.string   "measure_generating_regulation_id"
    t.integer  "justification_regulation_role"
    t.string   "justification_regulation_id"
    t.boolean  "stopped_flag"
    t.integer  "geographical_area_sid"
    t.integer  "goods_nomenclature_sid"
    t.string   "ordernumber"
    t.integer  "additional_code_type"
    t.string   "additional_code"
    t.string   "additional_code_sid"
    t.integer  "reduction_indicator"
    t.string   "export_refund_nomenclature_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measures", ["additional_code_sid"], :name => "index_measures_on_additional_code_sid"
  add_index "measures", ["geographical_area_sid"], :name => "index_measures_on_geographical_area_sid"
  add_index "measures", ["goods_nomenclature_sid"], :name => "index_measures_on_goods_nomenclature_sid"
  add_index "measures", ["justification_regulation_role", "justification_regulation_id"], :name => "justification_regulation"
  add_index "measures", ["measure_generating_regulation_role", "measure_generating_regulation_id"], :name => "measure_generating_regulation"
  add_index "measures", ["measure_sid"], :name => "primary_key", :unique => true
  add_index "measures", ["measure_type"], :name => "index_measures_on_measure_type"

  create_table "meursing_additional_codes", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "meursing_additional_code_sid"
    t.integer  "additional_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "validity_end_date"
  end

  add_index "meursing_additional_codes", ["meursing_additional_code_sid"], :name => "primary_key", :unique => true

  create_table "meursing_heading_texts", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "meursing_table_plan_id"
    t.integer  "meursing_heading_number"
    t.integer  "row_column_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meursing_heading_texts", ["meursing_table_plan_id", "meursing_heading_number", "row_column_code"], :name => "primary_key", :unique => true

  create_table "meursing_headings", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "meursing_table_plan_id"
    t.integer  "meursing_heading_number"
    t.integer  "row_column_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meursing_headings", ["meursing_table_plan_id", "meursing_heading_number", "row_column_code"], :name => "primary_key", :unique => true

  create_table "meursing_subheadings", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "meursing_table_plan_id"
    t.integer  "meursing_heading_number"
    t.integer  "row_column_code"
    t.integer  "subheading_sequence_number"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meursing_subheadings", ["meursing_table_plan_id", "meursing_heading_number", "row_column_code", "subheading_sequence_number"], :name => "primary_key", :unique => true

  create_table "meursing_table_cell_components", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "meursing_additional_code_sid"
    t.string   "meursing_table_plan_id"
    t.integer  "heading_number"
    t.integer  "row_column_code"
    t.integer  "subheading_sequence_number"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "additional_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meursing_table_cell_components", ["meursing_table_plan_id", "heading_number", "row_column_code", "meursing_additional_code_sid"], :name => "primary_key", :unique => true

  create_table "meursing_table_plans", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "meursing_table_plan_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meursing_table_plans", ["meursing_table_plan_id"], :name => "primary_key", :unique => true

  create_table "mfcm", :id => false, :force => true do |t|
    t.datetime "fe_tsmp"
    t.string   "msrgp_code"
    t.string   "msr_type"
    t.string   "tty_code"
    t.datetime "le_tsmp"
    t.datetime "audit_tsmp"
    t.string   "cmdty_code"
    t.string   "cmdty_msr_xhdg"
    t.string   "null_tri_rqd"
    t.boolean  "exports_use_ind"
  end

  create_table "modification_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "modification_regulation_role"
    t.string   "modification_regulation_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.integer  "base_regulation_role"
    t.string   "base_regulation_id"
    t.integer  "replacement_indicator"
    t.boolean  "stopped_flag"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.integer  "explicit_abrogation_regulation_role"
    t.string   "explicit_abrogation_regulation_id"
    t.date     "effective_end_date"
    t.integer  "complete_abrogation_regulation_role"
    t.string   "complete_abrogation_regulation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modification_regulations", ["base_regulation_id", "base_regulation_role"], :name => "base_regulation"
  add_index "modification_regulations", ["complete_abrogation_regulation_id", "complete_abrogation_regulation_role"], :name => "complete_abrogation_regulation"
  add_index "modification_regulations", ["explicit_abrogation_regulation_id", "explicit_abrogation_regulation_role"], :name => "explicit_abrogation_regulation"
  add_index "modification_regulations", ["modification_regulation_id", "modification_regulation_role"], :name => "primary_key", :unique => true

  create_table "monetary_exchange_periods", :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "monetary_exchange_period_sid"
    t.string   "parent_monetary_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monetary_exchange_periods", ["monetary_exchange_period_sid", "parent_monetary_unit_code"], :name => "primary_key", :unique => true

  create_table "monetary_exchange_rates", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "monetary_exchange_period_sid"
    t.string   "child_monetary_unit_code"
    t.decimal  "exchange_rate",                :precision => 16, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monetary_exchange_rates", ["monetary_exchange_period_sid", "child_monetary_unit_code"], :name => "primary_key", :unique => true

  create_table "monetary_unit_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "monetary_unit_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monetary_unit_descriptions", ["language_id"], :name => "index_monetary_unit_descriptions_on_language_id"
  add_index "monetary_unit_descriptions", ["monetary_unit_code"], :name => "primary_key", :unique => true

  create_table "monetary_units", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "monetary_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monetary_units", ["monetary_unit_code"], :name => "primary_key", :unique => true

  create_table "nomenclature_group_memberships", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "goods_nomenclature_sid"
    t.string   "goods_nomenclature_group_type"
    t.string   "goods_nomenclature_group_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nomenclature_group_memberships", ["goods_nomenclature_sid", "goods_nomenclature_group_id", "goods_nomenclature_group_type", "goods_nomenclature_item_id", "validity_start_date"], :name => "primary_key", :unique => true

  create_table "prorogation_regulation_actions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "prorogation_regulation_role"
    t.string   "prorogation_regulation_id"
    t.integer  "prorogated_regulation_role"
    t.string   "prorogated_regulation_id"
    t.date     "prorogated_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prorogation_regulation_actions", ["prorogation_regulation_id", "prorogation_regulation_role", "prorogated_regulation_id", "prorogated_regulation_role"], :name => "primary_key", :unique => true

  create_table "prorogation_regulations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "prorogation_regulation_role"
    t.string   "prorogation_regulation_id"
    t.date     "published_date"
    t.string   "officialjournal_number"
    t.integer  "officialjournal_page"
    t.integer  "replacement_indicator"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prorogation_regulations", ["prorogation_regulation_id", "prorogation_regulation_role"], :name => "primary_key", :unique => true

  create_table "quota_associations", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "main_quota_definition_sid"
    t.integer  "sub_quota_definition_sid"
    t.string   "relation_type"
    t.decimal  "coefficient",               :precision => 16, :scale => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_associations", ["main_quota_definition_sid", "sub_quota_definition_sid"], :name => "primary_key", :unique => true

  create_table "quota_balance_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "last_import_date_in_allocation"
    t.integer  "old_balance"
    t.integer  "new_balance"
    t.integer  "imported_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_balance_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "quota_blocking_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_blocking_period_sid"
    t.integer  "quota_definition_sid"
    t.date     "blocking_start_date"
    t.date     "blocking_end_date"
    t.integer  "blocking_period_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_blocking_periods", ["quota_blocking_period_sid"], :name => "primary_key", :unique => true

  create_table "quota_critical_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.string   "critical_state"
    t.date     "critical_state_change_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_critical_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "quota_definitions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.string   "quota_order_number_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "quota_order_number_sid"
    t.integer  "volume"
    t.integer  "initial_volume"
    t.string   "measurement_unit_code"
    t.integer  "maximum_precision"
    t.string   "critical_state"
    t.integer  "critical_threshold"
    t.string   "monetary_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_definitions", ["measurement_unit_code"], :name => "index_quota_definitions_on_measurement_unit_code"
  add_index "quota_definitions", ["measurement_unit_qualifier_code"], :name => "index_quota_definitions_on_measurement_unit_qualifier_code"
  add_index "quota_definitions", ["monetary_unit_code"], :name => "index_quota_definitions_on_monetary_unit_code"
  add_index "quota_definitions", ["quota_definition_sid"], :name => "primary_key", :unique => true
  add_index "quota_definitions", ["quota_order_number_id"], :name => "index_quota_definitions_on_quota_order_number_id"

  create_table "quota_exhaustion_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "exhaustion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_exhaustion_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "quota_order_number_origin_exclusions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_order_number_origin_sid"
    t.integer  "excluded_geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_order_number_origin_exclusions", ["quota_order_number_origin_sid", "excluded_geographical_area_sid"], :name => "primary_key", :unique => true

  create_table "quota_order_number_origins", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_order_number_origin_sid"
    t.integer  "quota_order_number_sid"
    t.string   "geographical_area_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_order_number_origins", ["geographical_area_sid"], :name => "index_quota_order_number_origins_on_geographical_area_sid"
  add_index "quota_order_number_origins", ["quota_order_number_origin_sid"], :name => "primary_key", :unique => true

  create_table "quota_order_numbers", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_order_number_sid"
    t.string   "quota_order_number_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_order_numbers", ["quota_order_number_sid"], :name => "primary_key", :unique => true

  create_table "quota_reopening_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "reopening_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_reopening_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "quota_suspension_periods", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_suspension_period_sid"
    t.integer  "quota_definition_sid"
    t.date     "suspension_start_date"
    t.date     "suspension_end_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_suspension_periods", ["quota_definition_sid"], :name => "index_quota_suspension_periods_on_quota_definition_sid"
  add_index "quota_suspension_periods", ["quota_suspension_period_sid"], :name => "primary_key", :unique => true

  create_table "quota_unblocking_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "unblocking_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_unblocking_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "quota_unsuspension_events", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "unsuspension_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quota_unsuspension_events", ["quota_definition_sid", "occurrence_timestamp"], :name => "primary_key", :unique => true

  create_table "regulation_group_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "regulation_group_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regulation_group_descriptions", ["language_id"], :name => "index_regulation_group_descriptions_on_language_id"
  add_index "regulation_group_descriptions", ["regulation_group_id"], :name => "primary_key", :unique => true

  create_table "regulation_groups", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "regulation_group_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regulation_groups", ["regulation_group_id"], :name => "primary_key", :unique => true

  create_table "regulation_replacements", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "geographical_area_id"
    t.string   "chapter_heading"
    t.integer  "replacing_regulation_role"
    t.string   "replacing_regulation_id"
    t.integer  "replaced_regulation_role"
    t.string   "replaced_regulation_id"
    t.integer  "measure_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regulation_replacements", ["replacing_regulation_id", "replacing_regulation_role", "replaced_regulation_id", "replaced_regulation_role", "measure_type_id", "geographical_area_id", "chapter_heading"], :name => "primary_key", :unique => true

  create_table "regulation_role_type_descriptions", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.string   "regulation_role_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regulation_role_type_descriptions", ["language_id"], :name => "index_regulation_role_type_descriptions_on_language_id"
  add_index "regulation_role_type_descriptions", ["regulation_role_type_id"], :name => "primary_key", :unique => true

  create_table "regulation_role_types", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "regulation_role_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

<<<<<<< HEAD
<<<<<<< HEAD
=======
  add_index "regulation_role_types", ["regulation_role_type_id"], :name => "primary_key", :unique => true

>>>>>>> Add end timestamps and db indexes. Fix primary keys wherever they were broken/incorrect.
  create_table "sections", :force => true do |t|
    t.integer  "position"
    t.string   "numeral"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tame", :force => true do |t|
=======
  create_table "tame", :id => false, :force => true do |t|
>>>>>>> mcfm table, remigrate and spec was wrong so renamed msgrm to msrgp
    t.datetime "fe_tsmp"
    t.string   "msrgp_code"
    t.string   "msr_type"
    t.string   "tty_code"
    t.string   "tar_msr_no"
    t.datetime "le_tsmp"
    t.decimal  "adval_rate",          :precision => 3, :scale => 3
    t.decimal  "alch_sgth",           :precision => 3, :scale => 2
    t.datetime "audit_tsmp"
    t.string   "cap_ai_stmt"
    t.decimal  "cap_max_pct",         :precision => 3, :scale => 3
    t.string   "cmdty_msr_xhdg"
    t.string   "comp_mthd"
    t.string   "cpc_wvr_phb"
    t.string   "ec_msr_set"
    t.string   "mip_band_exch"
    t.string   "mip_rate_exch"
    t.string   "mip_uoq_code"
    t.string   "nba_id"
    t.string   "null_tri_rqd"
    t.string   "qta_code_uk"
    t.string   "qta_elig_useLstrubg"
    t.string   "qta_exch_rate"
    t.string   "qta_no"
    t.string   "qta_uoq_code"
    t.text     "rfa"
    t.string   "rfs_code_1"
    t.string   "rfs_code_2"
    t.string   "rfs_code_3"
    t.string   "rfs_code_4"
    t.string   "rfs_code_5"
    t.string   "tdr_spr_sur"
    t.boolean  "exports_use_ind"
  end

  create_table "tamf", :id => false, :force => true do |t|
    t.datetime "fe_tsmp"
    t.string   "msrgp_code"
    t.string   "msr_type"
    t.string   "tty_code"
    t.string   "tar_msr_no"
    t.datetime "le_tsmp"
    t.decimal  "adval1_rate",    :precision => 3, :scale => 3
    t.decimal  "adval2_rate",    :precision => 3, :scale => 3
    t.string   "ai_factor"
    t.decimal  "cmdty_dmql",     :precision => 8, :scale => 3
    t.string   "cmdty_dmql_uoq"
    t.string   "cngp_code"
    t.string   "cntry_disp"
    t.string   "cntry_orig"
    t.string   "duty_type"
    t.string   "ec_supplement"
    t.string   "ec_exch_rate"
    t.string   "spcl_inst"
    t.string   "spfc1_cmpd_uoq"
    t.decimal  "spfc1_rate",     :precision => 7, :scale => 4
    t.string   "spfc1_uoq"
    t.decimal  "spfc2_rate",     :precision => 7, :scale => 4
    t.string   "spfc2_uoq"
    t.decimal  "spfc3_rate",     :precision => 7, :scale => 4
    t.string   "spfc3_uoq"
    t.string   "tamf_dt"
    t.string   "tamf_sta"
    t.string   "tamf_ty"
  end

  create_table "transmission_comments", :id => false, :force => true do |t|
    t.string   "record_code"
    t.string   "subrecord_code"
    t.string   "record_sequence_number"
    t.integer  "comment_sid"
    t.string   "language_id"
    t.text     "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transmission_comments", ["comment_sid", "language_id"], :name => "primary_key", :unique => true

end
