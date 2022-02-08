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

ActiveRecord::Schema.define(version: 2022_02_08_063519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id"
    t.bigint "plan_id"
    t.bigint "subscription_id"
    t.integer "wordpress_post_id"
    t.datetime "start_at", precision: 6
    t.datetime "end_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_memberships_on_plan_id"
    t.index ["subscription_id"], name: "index_memberships_on_subscription_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
    t.index ["wordpress_post_id"], name: "index_memberships_on_wordpress_post_id", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.string "product_type"
    t.bigint "product_id"
    t.string "name"
    t.integer "quantity"
    t.decimal "line_subtotal", precision: 10, scale: 2
    t.decimal "line_subtotal_tax", precision: 10, scale: 2
    t.decimal "line_total", precision: 10, scale: 2
    t.decimal "line_tax", precision: 10, scale: 2
    t.integer "wordpress_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_type", "product_id"], name: "index_order_items_on_product"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status"
    t.string "stripe_customer_id"
    t.string "stripe_source_id"
    t.string "payment_method"
    t.string "payment_method_title"
    t.decimal "order_total", precision: 8, scale: 2
    t.decimal "order_tax", precision: 8, scale: 2
    t.string "order_currency"
    t.datetime "paid_at", precision: 6
    t.datetime "completed_at", precision: 6
    t.string "wordpress_post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["wordpress_post_id"], name: "index_orders_on_wordpress_post_id", unique: true
  end

  create_table "plans", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.integer "wordpress_post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 0
    t.integer "wordpress_product_id"
    t.index ["wordpress_post_id"], name: "index_plans_on_wordpress_post_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "stripe_source_id"
    t.string "stripe_customer_id"
    t.decimal "order_total", precision: 8, scale: 2
    t.decimal "order_tax", precision: 8, scale: 2
    t.string "order_currency"
    t.string "payment_method_title"
    t.string "payment_method"
    t.integer "wordpress_post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.index ["wordpress_post_id"], name: "index_subscriptions_on_wordpress_post_id", unique: true
  end

  create_table "user_events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type"
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "occured_at", precision: 6
    t.index ["subject_type", "subject_id"], name: "index_user_events_on_subject"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "display_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "wordpress_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["wordpress_id"], name: "index_users_on_wordpress_id", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "memberships", "plans"
  add_foreign_key "memberships", "subscriptions"
  add_foreign_key "memberships", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_events", "users"
end
