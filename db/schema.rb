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

ActiveRecord::Schema[7.2].define(version: 2024_12_19_115411) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "pgsodium"
  create_schema "pgsodium_masks"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_graphql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "pgjwt"
  enable_extension "pgsodium"
  enable_extension "plpgsql"
  enable_extension "supabase_vault"
  enable_extension "uuid-ossp"

  create_table "device_alerts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "device_id", null: false
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.uuid "organisation_id"
    t.string "device_id"
    t.string "device_uuid"
    t.string "key"
    t.string "mac"
    t.string "serial_number"
    t.string "category"
    t.string "product_name"
    t.string "product_id"
    t.string "product_model"
    t.string "icon"
    t.jsonb "mapping", default: {}
    t.jsonb "dps", default: {}, null: false
    t.inet "ip"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inventory_label"
  end

  create_table "organisation_service_accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "api_key", null: false
    t.uuid "organisation_id"
    t.timestamptz "created_at", default: -> { "now()" }

    t.unique_constraint ["api_key"], name: "organisation_service_accounts_api_key_key"
  end

  create_table "organisations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "name", null: false
    t.timestamptz "created_at", default: -> { "now()" }
  end

  create_table "user_organisation_roles", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "organisation_id"
    t.text "role"
    t.timestamptz "created_at", default: -> { "now()" }
    t.check_constraint "role = ANY (ARRAY['admin'::text, 'viewer'::text])", name: "user_organisation_roles_role_check"
  end

  add_foreign_key "device_alerts", "devices", name: "device_alerts_device_id_fkey"
  add_foreign_key "devices", "organisations", name: "devices_organisation_id_fkey"
  add_foreign_key "organisation_service_accounts", "organisations", name: "organisation_service_accounts_organisation_id_fkey"
  add_foreign_key "user_organisation_roles", "auth.users", name: "user_organisation_roles_user_id_fkey"
  add_foreign_key "user_organisation_roles", "organisations", name: "user_organisation_roles_organisation_id_fkey"
end
