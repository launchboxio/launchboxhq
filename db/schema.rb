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

ActiveRecord::Schema[7.0].define(version: 2022_11_05_230911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addon_subscriptions", force: :cascade do |t|
    t.bigint "space_id"
    t.bigint "addon_id"
    t.string "chart"
    t.string "repo"
    t.string "version"
    t.string "release"
    t.string "namespace"
    t.string "value"
    t.string "values_merge_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_addon_subscriptions_on_addon_id"
    t.index ["space_id"], name: "index_addon_subscriptions_on_space_id"
  end

  create_table "addons", force: :cascade do |t|
    t.string "chart"
    t.string "repo"
    t.string "version"
    t.string "username_encrypted"
    t.string "password_encrypted"
    t.string "release"
    t.string "namespace"
    t.text "values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "clusters", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "version"
    t.string "provider"
    t.string "status"
    t.string "host"
    t.string "ca_crt_encrypted"
    t.string "token_encrypted"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_clusters_on_user_id"
  end

  create_table "space_user_accesses", force: :cascade do |t|
    t.bigint "space_id"
    t.bigint "user_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_space_user_accesses_on_space_id"
    t.index ["user_id"], name: "index_space_user_accesses_on_user_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.string "slug"
    t.bigint "cluster_id"
    t.bigint "user_id"
    t.integer "memory", default: 4096
    t.integer "cpu", default: 2
    t.integer "disk", default: 50
    t.integer "gpu", default: 0
    t.datetime "last_paused_at"
    t.datetime "last_started_at"
    t.text "last_error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id"], name: "index_spaces_on_cluster_id"
    t.index ["slug"], name: "index_spaces_on_slug", unique: true
    t.index ["user_id"], name: "index_spaces_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
