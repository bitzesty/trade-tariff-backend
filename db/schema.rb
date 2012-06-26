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

ActiveRecord::Schema.define(:version => 20120626161407) do

  create_table "additional_code_type_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "additional_code_type_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "additional_code_types", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.string   "code"
    t.string   "meursing_table_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificate_type_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "certificate_type_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certificate_types", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_type_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "footnote_type_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footnote_types", :id => false, :force => true do |t|
    t.string   "id"
    t.integer  "code"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "language_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "language_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_type_series", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.integer  "combination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_type_series_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "measure_type_series_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_group_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "regulation_group_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_groups", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_role_type_descriptions", :id => false, :force => true do |t|
    t.string   "id"
    t.string   "regulation_role_type_id"
    t.string   "language_id"
    t.text     "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regulation_role_types", :id => false, :force => true do |t|
    t.string   "id"
    t.date     "validity_start_date"
    t.date     "validity_end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
