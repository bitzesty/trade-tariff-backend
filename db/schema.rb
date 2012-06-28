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

ActiveRecord::Schema.define(:version => 20120628095611) do

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
    t.string   "duty_expression_description_id"
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

  create_table "footnote_association_erns", :force => true do |t|
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
    t.integer  "replacement_indicator"
    t.text     "information_text"
    t.boolean  "approved_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_area_description_periods", :force => true do |t|
    t.integer  "geographical_area_description_period_sid"
    t.integer  "geographical_area_sid"
    t.date     "validity_start_date"
    t.string   "geographical_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_area_descriptions", :force => true do |t|
    t.integer  "geographical_area_description_period_sid"
    t.string   "language_id"
    t.integer  "geographical_area_sid"
    t.string   "geographical_area_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_area_memberships", :force => true do |t|
    t.integer  "geographical_area_sid"
    t.integer  "geographical_area_group_sid"
    t.date     "validity_start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographical_areas", :force => true do |t|
    t.integer  "geographical_area_sid"
    t.date     "validity_start_date"
    t.string   "geographical_code"
    t.string   "geographical_area_id"
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
    t.text     "measure_type_series_descriptions"
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

end
