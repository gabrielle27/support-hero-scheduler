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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150830163958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conflicts", force: :cascade do |t|
    t.integer "employee_id"
    t.date    "support_date"
  end

  add_index "conflicts", ["employee_id"], name: "index_conflicts_on_employee_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.string "name"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date   "support_date"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "employee_id"
    t.date    "support_date"
  end

  add_index "schedules", ["employee_id"], name: "index_schedules_on_employee_id", using: :btree

  create_table "swap_requests", force: :cascade do |t|
    t.integer "source_id"
    t.integer "target_id"
  end

  add_index "swap_requests", ["source_id"], name: "index_swap_requests_on_source_id", using: :btree
  add_index "swap_requests", ["target_id"], name: "index_swap_requests_on_target_id", using: :btree

end
