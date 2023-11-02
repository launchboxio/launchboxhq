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

ActiveRecord::Schema[7.0].define(version: 2023_11_02_014315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addon_subscriptions", force: :cascade do |t|
    t.bigint "project_id"
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
    t.json "overrides"
    t.string "name"
    t.json "mappings"
    t.index ["addon_id"], name: "index_addon_subscriptions_on_addon_id"
    t.index ["project_id"], name: "index_addon_subscriptions_on_project_id"
  end

  create_table "addon_versions", force: :cascade do |t|
    t.bigint "addon_id"
    t.string "version"
    t.string "claim_name"
    t.boolean "default"
    t.string "group"
    t.json "schema"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_addon_versions_on_addon_id"
  end

  create_table "addons", force: :cascade do |t|
    t.string "name"
    t.boolean "cluster_attachable"
    t.boolean "project_attachable"
    t.text "definition"
    t.text "json_schema"
    t.text "mapping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oci_registry"
    t.string "oci_version"
    t.text "template"
    t.string "activation_policy"
    t.string "pull_policy"
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

  create_table "agents", force: :cascade do |t|
    t.bigint "cluster_id"
    t.datetime "last_communication"
    t.string "status"
    t.string "ip_address"
    t.string "pod_name"
    t.string "node_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id"], name: "index_agents_on_cluster_id"
  end

  create_table "auth_cluster_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auth_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cluster_addon_subscriptions", force: :cascade do |t|
    t.bigint "cluster_id"
    t.bigint "cluster_addon_id"
    t.string "chart"
    t.string "repo"
    t.string "version"
    t.string "release"
    t.string "namespace"
    t.string "value"
    t.string "values_merge_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_addon_id"], name: "index_cluster_addon_subscriptions_on_cluster_addon_id"
    t.index ["cluster_id"], name: "index_cluster_addon_subscriptions_on_cluster_id"
  end

  create_table "cluster_addons", force: :cascade do |t|
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

  create_table "clusters", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "region"
    t.string "version"
    t.string "provider"
    t.string "status"
    t.string "host"
    t.string "ca_crt_encrypted"
    t.string "token_encrypted"
    t.string "connection_method"
    t.boolean "managed", default: false
    t.bigint "oauth_application_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "manifest"
    t.boolean "agent_connected"
    t.datetime "agent_last_ping"
    t.string "agent_identifier"
    t.string "agent_version"
    t.index ["oauth_application_id"], name: "index_clusters_on_oauth_application_id"
    t.index ["user_id"], name: "index_clusters_on_user_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.string "name"
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_openid_requests", force: :cascade do |t|
    t.bigint "access_grant_id", null: false
    t.string "nonce", null: false
    t.index ["access_grant_id"], name: "index_oauth_openid_requests_on_access_grant_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "email"
    t.boolean "is_verified"
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "projects", force: :cascade do |t|
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
    t.string "host"
    t.text "ca_crt_encrypted"
    t.string "token_encrypted"
    t.index ["cluster_id"], name: "index_projects_on_cluster_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "projects_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_projects_users_on_project_id"
    t.index ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_projects_users_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "email"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_tenants_on_domain", unique: true
    t.index ["name"], name: "index_tenants_on_name", unique: true
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
    t.boolean "admin", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vcs_connections", force: :cascade do |t|
    t.bigint "user_id"
    t.string "method", default: "oauth"
    t.string "provider"
    t.string "host"
    t.string "email"
    t.string "uid"
    t.string "access_token_encrypted"
    t.string "refresh_token_encrypted"
    t.datetime "expiry", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vcs_connections_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_openid_requests", "oauth_access_grants", column: "access_grant_id", on_delete: :cascade
  add_foreign_key "taggings", "tags"
end
