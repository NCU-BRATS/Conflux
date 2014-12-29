# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141221170406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["leader_id"], name: "index_groups_on_leader_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.integer  "sequential_id"
    t.string   "status",        limit: 255
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "sprint_id"
    t.datetime "begin_at"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree
  add_index "issues", ["sprint_id"], name: "index_issues_on_sprint_id", using: :btree
  add_index "issues", ["user_id"], name: "index_issues_on_user_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",        limit: 255
  end

  add_index "projects", ["name"], name: "index_projects_on_name", unique: true, using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "link",       limit: 255
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repositories", ["project_id"], name: "index_repositories_on_project_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.integer  "sequential_id"
    t.string   "status",        limit: 255
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "begin_at"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree
  add_index "sprints", ["user_id"], name: "index_sprints_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "title",                  limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_groups", ["group_id"], name: "index_users_groups_on_group_id", using: :btree
  add_index "users_groups", ["user_id"], name: "index_users_groups_on_user_id", using: :btree

  create_table "users_issues", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_issues", ["issue_id"], name: "index_users_issues_on_issue_id", using: :btree
  add_index "users_issues", ["user_id"], name: "index_users_issues_on_user_id", using: :btree

  create_table "users_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_projects", ["project_id"], name: "index_users_projects_on_project_id", using: :btree
  add_index "users_projects", ["user_id"], name: "index_users_projects_on_user_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "voter_id"
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
