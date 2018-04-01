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

ActiveRecord::Schema.define(version: 20180331134942) do

  create_table "project_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "role", default: 0, null: false
    t.integer "target_hours", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_project_members_on_discarded_at"
    t.index ["project_id"], name: "index_project_members_on_project_id"
    t.index ["user_id", "project_id"], name: "index_project_members_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_project_members_on_user_id"
  end

  create_table "project_members_progresses", id: false, force: :cascade do |t|
    t.integer "project_member_id", null: false
    t.integer "project_progress_id", null: false
    t.index ["project_member_id", "project_progress_id"], name: "index_project_members_progresses_member_id_progress_id", unique: true
    t.index ["project_progress_id", "project_member_id"], name: "index_project_members_progresses_progress_id_member_id", unique: true
  end

  create_table "project_progresses", force: :cascade do |t|
    t.integer "project_id", null: false
    t.datetime "start", null: false
    t.datetime "end"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_project_progresses_on_discarded_at"
    t.index ["project_id"], name: "index_project_progresses_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "projects"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_projects_on_discarded_at"
    t.index ["name"], name: "index_projects_on_name"
  end

  create_table "tag_affecteds", force: :cascade do |t|
    t.integer "project_member_id"
    t.integer "tag_id"
    t.string "affected_type"
    t.integer "affected_id"
    t.index ["affected_type", "affected_id"], name: "index_tag_affecteds_on_affected_type_and_affected_id"
    t.index ["project_member_id", "tag_id", "affected_type", "affected_id"], name: "index_tag_affecteds_on_everything", unique: true
    t.index ["project_member_id"], name: "index_tag_affecteds_on_project_member_id"
    t.index ["tag_id"], name: "index_tag_affecteds_on_tag_id"
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
