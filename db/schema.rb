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

ActiveRecord::Schema.define(:version => 20120626164513) do

  create_table "additional_code_type_descriptions", :id => false, :force => true do |t|
    t.string   "additional_code_type_id"
    t.string   "language_id"
    t.text     "description"
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
    t.string   "footnote_type"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
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
