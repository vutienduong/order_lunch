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

ActiveRecord::Schema.define(version: 20180605015854) do

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "author_id"
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id"

  create_table "daily_restaurants", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "dish_id"
    t.date     "date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "dish_component_associations", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "dish_id"
    t.integer  "dished_component_id"
  end

  create_table "dish_orders", force: :cascade do |t|
    t.integer  "dish_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dish_restaurant_associations", force: :cascade do |t|
    t.integer "dish_id"
    t.integer "restaurant_id"
  end

  create_table "dished_components", force: :cascade do |t|
    t.string "name"
    t.string "category"
  end

  create_table "dishes", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "name"
    t.decimal  "price"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.binary   "image"
    t.string   "image_logo_file_name"
    t.string   "image_logo_content_type"
    t.integer  "image_logo_file_size"
    t.datetime "image_logo_updated_at"
    t.boolean  "sizeable"
    t.boolean  "componentable"
    t.integer  "tags_id"
    t.string   "size"
    t.integer  "parent_id"
    t.text     "group_name"
    t.integer  "once"
  end

  add_index "dishes", ["parent_id"], name: "index_dishes_on_parent_id"
  add_index "dishes", ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  add_index "dishes", ["tags_id"], name: "index_dishes_on_tags_id"

  create_table "dishes_tags", force: :cascade do |t|
    t.integer "tags_id"
    t.integer "dish_id"
    t.integer "tag_id"
  end

  create_table "foods", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.text     "creator"
    t.datetime "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "general_settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "menu_histories", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "actor_id"
    t.datetime "datetime"
    t.text     "content"
  end

  add_index "menu_histories", ["menu_id"], name: "index_menu_histories_on_menu_id"

  create_table "menu_restaurants", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "locked_at"
  end

  create_table "menus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "date"
    t.integer  "is_lock"
    t.datetime "locked_at"
  end

  create_table "notices", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "author_id"
  end

  add_index "notices", ["author_id"], name: "index_notices_on_author_id"

  create_table "ol_configs", force: :cascade do |t|
    t.text "name"
    t.text "value"
    t.text "note"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "note"
    t.integer  "total_price"
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

  create_table "personal_settings", force: :cascade do |t|
    t.integer "user_id"
    t.string  "key"
    t.string  "value"
  end

  add_index "personal_settings", ["user_id"], name: "index_personal_settings_on_user_id"

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "provider_dish_mappings", force: :cascade do |t|
    t.integer "daily_restaurant_id"
    t.integer "dish_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "phone"
    t.binary   "image"
    t.string   "image_logo_file_name"
    t.string   "image_logo_content_type"
    t.integer  "image_logo_file_size"
    t.datetime "image_logo_updated_at"
    t.string   "ref_link"
    t.text     "description"
    t.boolean  "is_provider"
  end

  create_table "salad_components", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "salad_components", ["dish_id"], name: "index_salad_components_on_dish_id"

  create_table "sized_prices", force: :cascade do |t|
    t.string   "size"
    t.decimal  "price"
    t.integer  "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sized_prices", ["dish_id"], name: "index_sized_prices_on_dish_id"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "dishes_id"
  end

  add_index "tags", ["dishes_id"], name: "index_tags_on_dishes_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email"
    t.string   "password_digest"
    t.integer  "admin"
    t.string   "slack_name"
  end

end
