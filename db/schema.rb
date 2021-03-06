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

ActiveRecord::Schema.define(version: 20180603125119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "team_member_target_hours", force: :cascade do |t|
    t.bigint "team_member_id"
    t.date "since", null: false
    t.integer "hours", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_team_member_target_hours_on_discarded_at"
    t.index ["since", "team_member_id"], name: "index_team_member_target_hours_on_since_and_team_member_id", unique: true
    t.index ["team_member_id"], name: "index_team_member_target_hours_on_team_member_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.boolean "show_online_status", default: true
    t.boolean "show_tracking_status", default: true
    t.index ["discarded_at"], name: "index_team_members_on_discarded_at"
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id", "team_id"], name: "index_team_members_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "team_progresses", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "team_member_id", null: false
    t.datetime "start", null: false
    t.datetime "end"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_team_progresses_on_discarded_at"
    t.index ["team_id"], name: "index_team_progresses_on_team_id"
    t.index ["team_member_id"], name: "index_team_progresses_on_team_member_id"
  end

  create_table "team_unavailabilities", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "team_member_id", null: false
    t.date "start", null: false
    t.date "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.text "description"
    t.index ["discarded_at"], name: "index_team_unavailabilities_on_discarded_at"
    t.index ["team_id"], name: "index_team_unavailabilities_on_team_id"
    t.index ["team_member_id"], name: "index_team_unavailabilities_on_team_member_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.integer "access", default: 0, null: false
    t.index ["ancestry"], name: "index_teams_on_ancestry"
    t.index ["discarded_at"], name: "index_teams_on_discarded_at"
    t.index ["name", "ancestry"], name: "index_teams_on_name_and_ancestry", unique: true
    t.index ["name"], name: "index_teams_on_name"
  end

  create_table "user_identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "secret"
    t.string "profile_page"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_user_identities_on_discarded_at"
    t.index ["user_id", "provider"], name: "index_user_identities_on_user_id_and_provider", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "role", default: 0, null: false
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "department"
    t.date "birth_date"
    t.string "avatar_type", default: "generator", null: false
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "authentication_token", limit: 30
    t.string "generated_avatar_url"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "team_member_target_hours", "team_members"
  add_foreign_key "team_members", "teams"
  add_foreign_key "team_members", "users"
  add_foreign_key "team_progresses", "team_members"
  add_foreign_key "team_progresses", "teams"
  add_foreign_key "team_unavailabilities", "team_members"
  add_foreign_key "team_unavailabilities", "teams"
  add_foreign_key "user_identities", "users"
end
