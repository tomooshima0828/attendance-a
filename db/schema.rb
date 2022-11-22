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

ActiveRecord::Schema.define(version: 20210512071430) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.datetime "started_at_before"
    t.datetime "finished_at_before"
    t.datetime "started_at_edited"
    t.datetime "finished_at_edited"
    t.datetime "estimated_overtime_hours"
    t.string "business_process_content"
    t.boolean "next_day_overtime", default: false
    t.boolean "next_day_working_hours", default: false
    t.integer "selector_overtime_request", default: 0
    t.integer "selector_working_hours_request", default: 0
    t.integer "selector_monthly_request", default: 0
    t.date "date_monthly_request"
    t.boolean "change_overtime", default: false
    t.boolean "change_working_hours", default: false
    t.boolean "change_monthly", default: false
    t.string "status_overtime"
    t.string "status_working_hours"
    t.string "status_monthly"
    t.datetime "year_starting"
    t.datetime "year_ending"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "branch_offices", force: :cascade do |t|
    t.string "branch_office_name"
    t.string "branch_office_number"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "affiliation"
    t.integer "employee_number"
    t.string "uid"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "basic_work_time", default: "2022-11-21 23:00:00"
    t.datetime "designated_work_start_time", default: "2022-11-22 00:00:00"
    t.datetime "designated_work_end_time", default: "2022-11-22 09:00:00"
    t.boolean "admin", default: false
    t.boolean "superior", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
