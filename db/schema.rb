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

ActiveRecord::Schema.define(version: 20180402164842) do

  create_table "tag_targets", force: :cascade do |t|
    t.integer "team_member_id"
    t.integer "tag_id"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_tag_targets_on_discarded_at"
    t.index ["tag_id"], name: "index_tag_targets_on_tag_id"
    t.index ["target_type", "target_id"], name: "index_tag_targets_on_target_type_and_target_id"
    t.index ["team_member_id", "tag_id", "target_type", "target_id"], name: "index_tag_affecteds_on_everything", unique: true
    t.index ["team_member_id"], name: "index_tag_targets_on_team_member_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_tags_on_discarded_at"
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "team_member_target_hours", force: :cascade do |t|
    t.integer "team_member_id"
    t.date "since", null: false
    t.integer "hours", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_team_member_target_hours_on_discarded_at"
    t.index ["team_member_id"], name: "index_team_member_target_hours_on_team_member_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "team_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_team_members_on_discarded_at"
    t.index ["team_id"], name: "index_team_members_on_team_id"
    t.index ["user_id", "team_id"], name: "index_team_members_on_user_id_and_team_id", unique: true
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "team_progresses", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "team_member_id", null: false
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

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["ancestry"], name: "index_teams_on_ancestry"
    t.index ["discarded_at"], name: "index_teams_on_discarded_at"
    t.index ["name", "ancestry"], name: "index_teams_on_name_and_ancestry", unique: true
    t.index ["name"], name: "index_teams_on_name"
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
    t.integer "role", default: 0, null: false
    t.string "username", null: false
    t.string "realname", null: false
    t.string "department"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
