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

ActiveRecord::Schema[7.1].define(version: 2024_10_24_054723) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "dependencies", id: :serial, force: :cascade do |t|
    t.string "requirements", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "rubygem_id"
    t.integer "version_id"
    t.string "scope", limit: 255
    t.string "unresolved_name", limit: 255
    t.index ["rubygem_id"], name: "index_dependencies_on_rubygem_id"
    t.index ["unresolved_name"], name: "index_dependencies_on_unresolved_name"
    t.index ["version_id"], name: "index_dependencies_on_version_id"
  end

  create_table "gem_downloads", id: :serial, force: :cascade do |t|
    t.integer "rubygem_id", null: false
    t.integer "version_id", null: false
    t.bigint "count"
    t.index ["count"], name: "index_gem_downloads_on_count", order: :desc
    t.index ["rubygem_id", "version_id"], name: "index_gem_downloads_on_rubygem_id_and_version_id", unique: true
    t.index ["version_id", "rubygem_id", "count"], name: "index_gem_downloads_on_version_id_and_rubygem_id_and_count"
  end

  create_table "linksets", id: :serial, force: :cascade do |t|
    t.integer "rubygem_id"
    t.string "home", limit: 255
    t.string "wiki", limit: 255
    t.string "docs", limit: 255
    t.string "mail", limit: 255
    t.string "code", limit: 255
    t.string "bugs", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["rubygem_id"], name: "index_linksets_on_rubygem_id"
  end

  create_table "rubygems", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "indexed", default: false, null: false
    t.index "regexp_replace(upper((name)::text), '[_-]'::text, ''::text, 'g'::text)", name: "dashunderscore_typos_idx"
    t.index "upper((name)::text) varchar_pattern_ops", name: "index_rubygems_upcase"
    t.index ["indexed"], name: "index_rubygems_on_indexed"
    t.index ["name"], name: "index_rubygems_on_name", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.text "authors"
    t.text "description"
    t.string "number", limit: 255
    t.integer "rubygem_id"
    t.datetime "built_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "summary"
    t.string "platform", limit: 255
    t.datetime "created_at", precision: nil
    t.boolean "indexed", default: true
    t.boolean "prerelease"
    t.integer "position"
    t.boolean "latest"
    t.string "full_name", limit: 255
    t.string "licenses", limit: 255
    t.integer "size"
    t.text "requirements"
    t.string "required_ruby_version", limit: 255
    t.string "sha256", limit: 255
    t.hstore "metadata", default: {}, null: false
    t.string "required_rubygems_version", limit: 255
    t.datetime "yanked_at", precision: nil
    t.string "info_checksum"
    t.string "yanked_info_checksum"
    t.bigint "pusher_id"
    t.string "canonical_number"
    t.text "cert_chain"
    t.bigint "pusher_api_key_id"
    t.string "gem_platform"
    t.string "gem_full_name"
    t.string "spec_sha256", limit: 44
    t.integer "download_status", default: 0
    t.index "lower((full_name)::text)", name: "index_versions_on_lower_full_name"
    t.index "lower((gem_full_name)::text)", name: "index_versions_on_lower_gem_full_name"
    t.index ["built_at"], name: "index_versions_on_built_at"
    t.index ["canonical_number", "rubygem_id", "platform"], name: "index_versions_on_canonical_number_and_rubygem_id_and_platform", unique: true
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["full_name"], name: "index_versions_on_full_name"
    t.index ["indexed", "yanked_at"], name: "index_versions_on_indexed_and_yanked_at"
    t.index ["number"], name: "index_versions_on_number"
    t.index ["position", "rubygem_id"], name: "index_versions_on_position_and_rubygem_id"
    t.index ["prerelease"], name: "index_versions_on_prerelease"
    t.index ["pusher_api_key_id"], name: "index_versions_on_pusher_api_key_id"
    t.index ["pusher_id"], name: "index_versions_on_pusher_id"
    t.index ["rubygem_id", "number", "platform"], name: "index_versions_on_rubygem_id_and_number_and_platform", unique: true
  end

  add_foreign_key "linksets", "rubygems", name: "linksets_rubygem_id_fk"
  add_foreign_key "versions", "rubygems", name: "versions_rubygem_id_fk"
end
