# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_11_14_044034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_records", force: :cascade do |t|
    t.integer "bill_id"
    t.boolean "paid", default: false
    t.date "date"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bill_records_pay_period_breakdowns", id: false, force: :cascade do |t|
    t.bigint "bill_record_id"
    t.bigint "pay_period_breakdown_id"
    t.index ["bill_record_id"], name: "index_bill_records_pay_period_breakdowns_on_bill_record_id"
    t.index ["pay_period_breakdown_id"], name: "idx_on_pay_period_breakdown_id_c7a1b0aab0"
  end

  create_table "bills", force: :cascade do |t|
    t.string "name"
    t.integer "date_number"
    t.integer "amount"
    t.integer "payment_source_id"
    t.text "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_each_paycheck", default: false
  end

  create_table "pay_period_breakdowns", force: :cascade do |t|
    t.integer "paycheck_amount"
    t.date "pay_date"
    t.date "next_pay_date"
    t.integer "pay_frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bill_total"
  end

  create_table "payment_sources", force: :cascade do |t|
    t.string "name"
    t.integer "payment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
