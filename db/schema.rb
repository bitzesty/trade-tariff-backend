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

ActiveRecord::Schema.define(:version => 20120628163107) do

  create_table "additional_code_description_periods", :id => false, :force => true do |t|
    t.string   "additional_code_description_period_sid"
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_code_descriptions", :id => false, :force => true do |t|
    t.string   "additional_code_description_period_sid"
    t.string   "language_id"
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_code_type_descriptions", :id => false, :force => true do |t|
    t.string   "additional_code_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_code_type_measure_types", :id => false, :force => true do |t|
    t.string   "measure_type_id"
    t.string   "additional_code_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_code_types", :id => false, :force => true do |t|
    t.string   "additional_code_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "application_code"
    t.string   "meursing_table_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_codes", :id => false, :force => true do |t|
    t.string   "additional_code_sid"
    t.string   "additional_code_type_id"
    t.string   "additional_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "base_regulations", :id => false, :force => true do |t|
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

  create_table "certificate_description_periods", :id => false, :force => true do |t|
    t.string   "certificate_description_period_sid"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificate_descriptions", :id => false, :force => true do |t|
    t.string   "certificate_description_period_sid"
    t.string   "language_id"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificate_type_descriptions", :id => false, :force => true do |t|
    t.string   "certificate_type_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificate_types", :id => false, :force => true do |t|
    t.string   "certificate_type_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificates", :id => false, :force => true do |t|
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "complete_abrogation_regulations", :id => false, :force => true do |t|
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

  create_table "duty_expression_descriptions", :id => false, :force => true do |t|
    t.string   "duty_expression_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duty_expressions", :id => false, :force => true do |t|
    t.string   "duty_expression_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "duty_amount_applicability_code"
    t.integer  "measurement_unit_applicability_code"
    t.integer  "monetary_unit_applicability_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "explicit_abrogation_regulations", :id => false, :force => true do |t|
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

  create_table "export_refund_nomenclature_description_periods", :id => false, :force => true do |t|
    t.string   "export_refund_nomenclature_description_period_sid"
    t.string   "export_refund_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "goods_nomenclature_item_id"
    t.integer  "additional_code_type"
    t.string   "export_refund_code"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_refund_nomenclature_descriptions", :id => false, :force => true do |t|
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

  create_table "export_refund_nomenclature_indents", :id => false, :force => true do |t|
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
  end

  create_table "export_refund_nomenclatures", :id => false, :force => true do |t|
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

  create_table "footnote_association_additional_codes", :id => false, :force => true do |t|
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

  create_table "footnote_association_erns", :id => false, :force => true do |t|
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

  create_table "footnote_association_goods_nomenclatures", :id => false, :force => true do |t|
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

  create_table "footnote_association_measures", :id => false, :force => true do |t|
    t.string   "measure_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_association_meursing_headings", :id => false, :force => true do |t|
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

  create_table "footnote_description_periods", :id => false, :force => true do |t|
    t.string   "footnote_description_period_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_descriptions", :id => false, :force => true do |t|
    t.string   "footnote_description_period_sid"
    t.string   "footnote_type_id"
    t.string   "footnote_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_type_descriptions", :id => false, :force => true do |t|
    t.string   "footnote_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_types", :id => false, :force => true do |t|
    t.string   "footnote_type_id"
    t.integer  "application_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnotes", :id => false, :force => true do |t|
    t.string   "footnote_id"
    t.string   "footnote_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fts_regulation_actions", :id => false, :force => true do |t|
    t.integer  "fts_regulation_role"
    t.string   "fts_regulation_id"
    t.integer  "stopped_regulation_role"
    t.string   "stopped_regulation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "full_temporary_stop_regulations", :id => false, :force => true do |t|
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

  create_table "geographical_area_description_periods", :id => false, :force => true do |t|
    t.integer  "geographical_area_description_period_sid"
    t.integer  "geographical_area_sid"
    t.date     "validity_start_date"
    t.string   "geographical_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_area_descriptions", :id => false, :force => true do |t|
    t.integer  "geographical_area_description_period_sid"
    t.string   "language_id"
    t.integer  "geographical_area_sid"
    t.string   "geographical_area_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_area_memberships", :id => false, :force => true do |t|
    t.integer  "geographical_area_sid"
    t.integer  "geographical_area_group_sid"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_areas", :id => false, :force => true do |t|
    t.integer  "geographical_area_sid"
    t.integer  "parent_geographical_area_group_sid"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "geographical_code"
    t.string   "geographical_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_description_periods", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_description_period_sid"
    t.integer  "goods_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_descriptions", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_description_period_sid"
    t.string   "language_id"
    t.integer  "goods_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_group_descriptions", :id => false, :force => true do |t|
    t.string   "goods_nomenclature_group_type"
    t.string   "goods_nomenclature_group_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_groups", :id => false, :force => true do |t|
    t.string   "goods_nomenclature_group_type"
    t.string   "goods_nomenclature_group_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "nomenclature_group_facility_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_indents", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_indent_sid"
    t.integer  "goods_nomenclature_sid"
    t.date     "validity_start_date"
    t.string   "number_indents"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_origins", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_sid"
    t.string   "derived_goods_nomenclature_item_id"
    t.string   "derived_productline_suffix"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclature_successors", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_sid"
    t.string   "absorbed_goods_nomenclature_item_id"
    t.string   "absorbed_productline_suffix"
    t.string   "goods_nomenclature_item_id"
    t.string   "productline_suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods_nomenclatures", :id => false, :force => true do |t|
    t.integer  "goods_nomenclature_sid"
    t.string   "goods_nomenclature_item_id"
    t.string   "producline_suffix"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "statistical_indicator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "language_descriptions", :id => false, :force => true do |t|
    t.string   "language_code_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :id => false, :force => true do |t|
    t.string   "language_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_action_descriptions", :id => false, :force => true do |t|
    t.string   "action_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_actions", :id => false, :force => true do |t|
    t.string   "action_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_components", :id => false, :force => true do |t|
    t.integer  "measure_sid"
    t.string   "duty_expression_id"
    t.integer  "duty_amount"
    t.string   "monetary_unit_code"
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_condition_code_descriptions", :id => false, :force => true do |t|
    t.string   "condition_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_condition_codes", :id => false, :force => true do |t|
    t.string   "condition_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_condition_components", :id => false, :force => true do |t|
    t.integer  "measure_condition_sid"
    t.string   "duty_expression_id"
    t.integer  "duty_amount"
    t.string   "monetary_unit_code"
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_conditions", :id => false, :force => true do |t|
    t.integer  "measure_condition_sid"
    t.integer  "measure_sid"
    t.string   "condition_code"
    t.integer  "component_sequence_number"
    t.integer  "condition_duty_amount"
    t.string   "condition_monetary_unit_code"
    t.string   "condition_measurement_unit_code"
    t.string   "action_code"
    t.string   "certificate_type_code"
    t.string   "certificate_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_excluded_geographical_areas", :id => false, :force => true do |t|
    t.integer  "measure_sid"
    t.string   "excluded_geographical_area"
    t.integer  "geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_partial_temporary_stops", :id => false, :force => true do |t|
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

  create_table "measure_type_descriptions", :id => false, :force => true do |t|
    t.integer  "measure_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_type_series", :id => false, :force => true do |t|
    t.string   "measure_type_series_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "measure_type_combination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_type_series_descriptions", :id => false, :force => true do |t|
    t.string   "measure_type_series_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_types", :id => false, :force => true do |t|
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

  create_table "measurement_unit_descriptions", :id => false, :force => true do |t|
    t.string   "measurement_unit_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_unit_qualifier_descriptions", :id => false, :force => true do |t|
    t.string   "measurement_unit_qualifier_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_unit_qualifiers", :id => false, :force => true do |t|
    t.string   "measurement_unit_qualifier_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurement_units", :id => false, :force => true do |t|
    t.string   "measurement_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", :id => false, :force => true do |t|
    t.string   "measurement_unit_code"
    t.string   "measurement_unit_qualifier_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measures", :id => false, :force => true do |t|
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

  create_table "meursing_additional_codes", :id => false, :force => true do |t|
    t.integer  "meursing_additional_code_sid"
    t.integer  "additional_code"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meursing_heading_texts", :id => false, :force => true do |t|
    t.string   "meursing_table_plan_id"
    t.integer  "meursing_heading_number"
    t.integer  "row_column_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meursing_headings", :id => false, :force => true do |t|
    t.string   "meursing_table_plan_id"
    t.integer  "meursing_heading_number"
    t.integer  "row_column_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meursing_subheadings", :id => false, :force => true do |t|
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

  create_table "meursing_table_cell_components", :id => false, :force => true do |t|
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

  create_table "meursing_table_plans", :id => false, :force => true do |t|
    t.string   "meursing_table_plan_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modification_regulations", :id => false, :force => true do |t|
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

  create_table "monetary_exchange_periods", :force => true do |t|
    t.string   "monetary_exchange_period_sid"
    t.string   "parent_monetary_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monetary_exchange_rates", :id => false, :force => true do |t|
    t.string   "monetary_exchange_period_sid"
    t.string   "child_monetary_unit_code"
    t.decimal  "exchange_rate",                :precision => 16, :scale => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monetary_unit_descriptions", :id => false, :force => true do |t|
    t.string   "monetary_unit_code"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monetary_units", :id => false, :force => true do |t|
    t.string   "monetary_unit_code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nomenclature_group_memberships", :id => false, :force => true do |t|
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

  create_table "prorogation_regulation_actions", :id => false, :force => true do |t|
    t.integer  "prorogation_regulation_role"
    t.string   "prorogation_regulation_id"
    t.integer  "prorogated_regulation_role"
    t.string   "prorogated_regulation_id"
    t.date     "prorogated_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prorogation_regulations", :id => false, :force => true do |t|
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

  create_table "quota_associations", :id => false, :force => true do |t|
    t.integer  "main_quota_definition_sid"
    t.integer  "sub_quota_definition_sid"
    t.string   "relation_type"
    t.decimal  "coefficient",               :precision => 16, :scale => 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_balance_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "last_import_date_in_allocation"
    t.integer  "old_balance"
    t.integer  "new_balance"
    t.integer  "imported_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_blocking_periods", :id => false, :force => true do |t|
    t.integer  "quota_blocking_period_sid"
    t.integer  "quota_definition_sid"
    t.date     "blocking_start_date"
    t.date     "blocking_end_date"
    t.integer  "blocking_period_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_critical_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.string   "critical_state"
    t.date     "critical_state_change_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_definitions", :id => false, :force => true do |t|
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

  create_table "quota_exhaustion_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "exhaustion_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_order_number_origin_exclusions", :id => false, :force => true do |t|
    t.integer  "quota_order_number_origin_sid"
    t.integer  "excluded_geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_order_number_origins", :id => false, :force => true do |t|
    t.integer  "quota_order_number_origin_sid"
    t.integer  "quota_order_number_sid"
    t.string   "geographical_area_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "geographical_area_sid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_order_numbers", :id => false, :force => true do |t|
    t.integer  "quota_order_number_sid"
    t.string   "quota_order_number_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_reopening_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "reopening_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_suspension_periods", :id => false, :force => true do |t|
    t.integer  "quota_suspension_period_sid"
    t.integer  "quota_definition_sid"
    t.date     "suspension_start_date"
    t.date     "suspension_end_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_unblocking_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "unblocking_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quota_unsuspension_events", :id => false, :force => true do |t|
    t.integer  "quota_definition_sid"
    t.datetime "occurrence_timestamp"
    t.date     "unsuspension_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_group_descriptions", :id => false, :force => true do |t|
    t.string   "regulation_group_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_groups", :id => false, :force => true do |t|
    t.string   "regulation_group_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_replacements", :id => false, :force => true do |t|
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

  create_table "regulation_role_type_descriptions", :id => false, :force => true do |t|
    t.string   "regulation_role_type_id"
    t.string   "language_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_role_types", :id => false, :force => true do |t|
    t.string   "regulation_role_type_id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transmission_comments", :id => false, :force => true do |t|
    t.integer  "comment_sid"
    t.string   "language_id"
    t.text     "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
