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

ActiveRecord::Schema[7.2].define(version: 2024_10_04_115047) do
  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "expenditures", force: :cascade do |t|
    t.integer "ie_statement_id", null: false
    t.string "category"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ie_statement_id"], name: "index_expenditures_on_ie_statement_id"
  end

  create_table "ie_statements", force: :cascade do |t|
    t.string "name"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rating"
    t.integer "disposable_income"
    t.index ["customer_id"], name: "index_ie_statements_on_customer_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.integer "ie_statement_id", null: false
    t.string "category"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ie_statement_id"], name: "index_incomes_on_ie_statement_id"
  end

  add_foreign_key "expenditures", "ie_statements"
  add_foreign_key "ie_statements", "customers"
  add_foreign_key "incomes", "ie_statements"
end
