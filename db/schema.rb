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

ActiveRecord::Schema.define(version: 20171014111650) do

  create_table "dish_orders", force: :cascade do |t|
    t.integer  "dish_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "image_url"
  end

  add_index "dishes", ["restaurant_id"], name: "index_dishes_on_restaurant_id"

  create_table "foods", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.text     "creator"
    t.datetime "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "menu_restaurants", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "menus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "date"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "orders_dishes", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "dish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders_dishes", ["dish_id"], name: "index_orders_dishes_on_dish_id"
  add_index "orders_dishes", ["order_id"], name: "index_orders_dishes_on_order_id"

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_logo"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "password_digest"
  end

end
