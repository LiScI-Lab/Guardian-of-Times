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
    t.integer "role", default: 0, null: false
  end

  create_table "project_progress_participants", force: :cascade do |t|
    t.integer "project_member_id"
    t.integer "project_progress_id"
    t.index ["project_member_id"], name: "index_project_progress_participants_on_project_member_id"
    t.index ["project_progress_id"], name: "index_project_progress_participants_on_project_progress_id"
  end

  create_table "project_progresses", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_project_progresses_on_discarded_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_projects_on_name"
  end

  create_table "tag_affecteds", force: :cascade do |t|
    t.integer "tags_id"
    t.string "affected_type"
    t.integer "affected_id"
    t.index ["affected_type", "affected_id"], name: "index_tag_affecteds_on_affected_type_and_affected_id"
    t.index ["tags_id"], name: "index_tag_affecteds_on_tags_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
