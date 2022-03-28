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

ActiveRecord::Schema.define(version: 2022_03_28_045623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "postcode"
    t.string "country_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_session_id"
    t.bigint "creator_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_availabilities_on_creator_id"
    t.index ["event_session_id"], name: "index_availabilities_on_event_session_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "event_bookings", force: :cascade do |t|
    t.bigint "event_session_id"
    t.bigint "user_id"
    t.bigint "order_item_id"
    t.string "status"
    t.integer "persons", default: 1
    t.integer "wordpress_post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "attendee"
    t.index ["event_session_id"], name: "index_event_bookings_on_event_session_id"
    t.index ["order_item_id"], name: "index_event_bookings_on_order_item_id"
    t.index ["user_id"], name: "index_event_bookings_on_user_id"
  end

  create_table "event_sessions", force: :cascade do |t|
    t.bigint "event_id"
    t.datetime "start_at", precision: 6
    t.datetime "end_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_sessions_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "author_id"
    t.string "slug"
    t.string "title"
    t.string "content"
    t.integer "wordpress_post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "short_description"
    t.bigint "image_id"
    t.string "type", default: "Events::SimpleEvent"
    t.boolean "duty_managed", default: false
    t.index ["author_id"], name: "index_events_on_author_id"
    t.index ["image_id"], name: "index_events_on_image_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "alt_text"
    t.string "caption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "wordpress_post_id"
    t.index ["wordpress_post_id"], name: "index_images_on_wordpress_post_id", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "imported_at", precision: 6
  end

  create_table "inductions", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_inductions_on_title", unique: true
  end

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
    t.index ["wordpress_id"], name: "index_order_items_on_wordpress_id", unique: true
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
    t.integer "wordpress_post_id"
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

  create_table "slack_users", force: :cascade do |t|
    t.string "slack_user_id"
    t.string "team_id"
    t.string "name"
    t.string "display_name"
    t.string "image_48"
    t.string "image_512"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_slack_users_on_user_id"
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

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: 6
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type"
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "occured_at", precision: 6
    t.json "data", default: {}
    t.index ["subject_type", "subject_id"], name: "index_user_events_on_subject"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "user_inductions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "induction_id"
    t.date "inducted_on", default: -> { "CURRENT_DATE" }
    t.index ["induction_id"], name: "index_user_inductions_on_induction_id"
    t.index ["user_id", "induction_id"], name: "index_user_inductions_on_user_id_and_induction_id", unique: true
    t.index ["user_id"], name: "index_user_inductions_on_user_id"
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
    t.integer "address_id"
    t.string "phone"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availabilities", "users", column: "creator_id"
  add_foreign_key "event_bookings", "event_sessions"
  add_foreign_key "event_bookings", "order_items"
  add_foreign_key "event_bookings", "users"
  add_foreign_key "event_sessions", "events"
  add_foreign_key "events", "images"
  add_foreign_key "events", "users", column: "author_id"
  add_foreign_key "memberships", "plans"
  add_foreign_key "memberships", "subscriptions"
  add_foreign_key "memberships", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "slack_users", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_events", "users"
  add_foreign_key "user_inductions", "inductions"
  add_foreign_key "user_inductions", "users"
  add_foreign_key "users", "addresses"
end
