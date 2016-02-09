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

ActiveRecord::Schema.define(version: 20160209230641) do

  create_table "customers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "address"
    t.string   "bid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.decimal  "duration",                precision: 8, scale: 2
    t.string   "description", limit: 255
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "salary"
    t.time     "begin"
    t.time     "end"
  end

  create_table "occurrances", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occurrances", ["order_id"], name: "index_occurrances_on_order_id"

  create_table "occurrences", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occurrences", ["order_id"], name: "index_occurrences_on_order_id"

  create_table "offers", force: :cascade do |t|
    t.string   "target",      limit: 255
    t.text     "contents"
    t.text     "execution"
    t.text     "delivery"
    t.text     "charge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.integer  "customer_id"
    t.string   "status",      limit: 255
    t.integer  "salary"
  end

  add_index "offers", ["customer_id"], name: "index_offers_on_customer_id"
  add_index "offers", ["place_id"], name: "index_offers_on_place_id"
  add_index "offers", ["status"], name: "index_offers_on_status"

  create_table "orders", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.decimal  "salary"
    t.string   "status",      limit: 255
    t.datetime "begin_at"
    t.datetime "end_at"
    t.boolean  "allday"
    t.text     "rule"
    t.datetime "until_at"
    t.string   "ical",        limit: 255
  end

  add_index "orders", ["offer_id"], name: "index_orders_on_offer_id"
  add_index "orders", ["status"], name: "index_orders_on_status"

  create_table "places", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "address"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["customer_id"], name: "index_places_on_customer_id"

  create_table "services", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.decimal  "price"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["offer_id"], name: "index_services_on_offer_id"

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "task_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gcalid",     limit: 255
  end

  add_index "tasks", ["order_id"], name: "index_tasks_on_order_id"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "address",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "roles_mask"
    t.string   "gcal",                   limit: 255
    t.string   "token"
    t.string   "uid"
    t.string   "provider"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
