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

ActiveRecord::Schema.define(version: 2018_12_10_225758) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.index ["author_id"], name: "index_comments_on_author_id"
  end

  create_table "daily_restaurants", id: :serial, force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "dish_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dish_component_associations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dish_id"
    t.integer "dished_component_id"
  end

  create_table "dish_components", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_components_on_dish_id"
  end

  create_table "dish_orders", id: :serial, force: :cascade do |t|
    t.integer "dish_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dish_restaurant_associations", id: :serial, force: :cascade do |t|
    t.integer "dish_id"
    t.integer "restaurant_id"
  end

  create_table "dished_components", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "category"
  end

  create_table "dishes", id: :serial, force: :cascade do |t|
    t.integer "restaurant_id"
    t.string "name"
    t.decimal "price"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "image"
    t.string "image_logo_file_name"
    t.string "image_logo_content_type"
    t.bigint "image_logo_file_size"
    t.datetime "image_logo_updated_at"
    t.boolean "sizeable"
    t.boolean "componentable"
    t.integer "tags_id"
    t.string "size"
    t.integer "parent_id"
    t.text "group_name"
    t.integer "once"
    t.string "external_id"
    t.index ["parent_id"], name: "index_dishes_on_parent_id"
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
    t.index ["tags_id"], name: "index_dishes_on_tags_id"
  end

  create_table "dishes_tags", id: :serial, force: :cascade do |t|
    t.integer "dish_id"
    t.integer "tag_id"
  end

  create_table "foods", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "creator"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_settings", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "menu_histories", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "actor_id"
    t.datetime "datetime"
    t.text "content"
    t.index ["menu_id"], name: "index_menu_histories_on_menu_id"
  end

  create_table "menu_restaurants", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "locked_at"
  end

  create_table "menus", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.integer "is_lock"
    t.datetime "locked_at"
  end

  create_table "notices", id: :serial, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.index ["author_id"], name: "index_notices_on_author_id"
  end

  create_table "ol_configs", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "value"
    t.text "note"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.integer "total_price"
    t.boolean "customizable", default: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "orders_dishes", id: :serial, force: :cascade do |t|
    t.integer "orders_id"
    t.integer "dish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["dish_id"], name: "index_orders_dishes_on_dish_id"
    t.index ["orders_id"], name: "index_orders_dishes_on_orders_id"
  end

  create_table "personal_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "key"
    t.string "value"
    t.index ["user_id"], name: "index_personal_settings_on_user_id"
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "provider_dish_mappings", id: :serial, force: :cascade do |t|
    t.integer "daily_restaurant_id"
    t.integer "dish_id"
  end

  create_table "restaurants", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.binary "image"
    t.string "image_logo_file_name"
    t.string "image_logo_content_type"
    t.bigint "image_logo_file_size"
    t.datetime "image_logo_updated_at"
    t.string "ref_link"
    t.text "description"
    t.integer "is_provider"
    t.string "external_id"
  end

  create_table "sized_prices", id: :serial, force: :cascade do |t|
    t.string "size"
    t.decimal "price"
    t.integer "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_sized_prices_on_dish_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "external_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.integer "admin"
    t.string "slack_name"
  end

  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "dish_components", "dishes"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "menu_histories", "menus"
  add_foreign_key "orders", "users"
  add_foreign_key "personal_settings", "users"
  add_foreign_key "sized_prices", "dishes"
end
