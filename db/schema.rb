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

ActiveRecord::Schema.define(version: 20150928063601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.string   "path"
    t.string   "controller"
    t.string   "action"
    t.string   "format"
    t.string   "remote_ip"
    t.jsonb    "headers"
    t.jsonb    "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "type"
    t.string   "path"
    t.string   "language"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_filename"
    t.integer  "size"
    t.jsonb    "liked_users",       default: []
    t.integer  "sequential_id"
    t.datetime "deleted_at"
  end

  add_index "attachments", ["deleted_at"], name: "index_attachments_on_deleted_at", using: :btree

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "announcement"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.text     "html"
    t.float    "order",         default: 0.0
    t.boolean  "archived",      default: false
    t.integer  "sequential_id"
    t.integer  "max_floor",     default: 0
  end

  add_index "channels", ["project_id"], name: "index_channels_on_project_id", using: :btree
  add_index "channels", ["slug"], name: "index_channels_on_slug", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html"
    t.json     "mentioned_list",   default: {}
    t.jsonb    "liked_users",      default: []
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.string   "title"
    t.integer  "project_id"
    t.integer  "action"
    t.integer  "author_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.jsonb    "target_json", default: {}, null: false
  end

  add_index "events", ["action"], name: "index_events_on_action", using: :btree
  add_index "events", ["author_id"], name: "index_events_on_author_id", using: :btree
  add_index "events", ["project_id"], name: "index_events_on_project_id", using: :btree
  add_index "events", ["target_id"], name: "index_events_on_target_id", using: :btree
  add_index "events", ["target_type"], name: "index_events_on_target_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["leader_id"], name: "index_groups_on_leader_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title"
    t.integer  "sequential_id"
    t.string   "status"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "sprint_id"
    t.datetime "begin_at"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignee_id"
    t.float    "order",         default: 0.0
    t.integer  "point",         default: 0
    t.text     "memo"
    t.text     "memo_html"
  end

  add_index "issues", ["assignee_id"], name: "index_issues_on_assignee_id", using: :btree
  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree
  add_index "issues", ["sprint_id"], name: "index_issues_on_sprint_id", using: :btree
  add_index "issues", ["user_id"], name: "index_issues_on_user_id", using: :btree

  create_table "jwt_tokens", force: :cascade do |t|
    t.integer  "exp"
    t.integer  "nbf"
    t.string   "iss"
    t.string   "aud"
    t.integer  "iat"
    t.string   "sub"
    t.datetime "last_used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "label_links", force: :cascade do |t|
    t.integer  "label_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "label_links", ["label_id"], name: "index_label_links_on_label_id", using: :btree
  add_index "label_links", ["target_id", "target_type"], name: "index_label_links_on_target_id_and_target_type", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "title"
    t.string   "color"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "labels", ["project_id"], name: "index_labels_on_project_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html"
    t.integer  "sequential_id"
  end

  add_index "messages", ["channel_id"], name: "index_messages_on_channel_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.integer  "author_id"
    t.integer  "owner_id"
    t.integer  "project_id"
    t.integer  "action"
    t.integer  "state"
    t.integer  "mode"
    t.jsonb    "target_json", default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "notices", ["action"], name: "index_notices_on_action", using: :btree
  add_index "notices", ["author_id"], name: "index_notices_on_author_id", using: :btree
  add_index "notices", ["mode"], name: "index_notices_on_mode", using: :btree
  add_index "notices", ["owner_id"], name: "index_notices_on_owner_id", using: :btree
  add_index "notices", ["project_id"], name: "index_notices_on_project_id", using: :btree
  add_index "notices", ["state"], name: "index_notices_on_state", using: :btree
  add_index "notices", ["target_id"], name: "index_notices_on_target_id", using: :btree
  add_index "notices", ["target_type"], name: "index_notices_on_target_type", using: :btree

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "participable_id"
    t.string   "participable_type"
    t.boolean  "subscribed",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["participable_type", "participable_id"], name: "index_participations_on_participable_type_and_participable_id", using: :btree
  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree

  create_table "polling_options", force: :cascade do |t|
    t.string   "title"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.jsonb    "voted_users", default: []
  end

  add_index "polling_options", ["poll_id"], name: "index_polling_options_on_poll_id", using: :btree

  create_table "polls", force: :cascade do |t|
    t.integer  "sequential_id"
    t.string   "title"
    t.string   "status"
    t.boolean  "allow_multiple_choice"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.jsonb    "results",               default: []
  end

  add_index "polls", ["project_id"], name: "index_polls_on_project_id", using: :btree
  add_index "polls", ["user_id"], name: "index_polls_on_user_id", using: :btree

  create_table "project_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_roles", ["project_id"], name: "index_project_roles_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "posts_count",             default: 0, null: false
    t.integer  "snippets_count",          default: 0, null: false
    t.integer  "images_count",            default: 0, null: false
    t.integer  "other_attachments_count", default: 0, null: false
    t.integer  "visibility_level"
  end

  add_index "projects", ["name"], name: "index_projects_on_name", unique: true, using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repositories", ["project_id"], name: "index_repositories_on_project_id", using: :btree

  create_table "rs_evaluations", force: :cascade do |t|
    t.string   "reputation_name"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.float    "value",           default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], name: "index_rs_evaluations_on_reputation_name_and_source_and_target", unique: true, using: :btree
  add_index "rs_evaluations", ["reputation_name"], name: "index_rs_evaluations_on_reputation_name", using: :btree
  add_index "rs_evaluations", ["source_id", "source_type"], name: "index_rs_evaluations_on_source_id_and_source_type", using: :btree
  add_index "rs_evaluations", ["target_id", "target_type"], name: "index_rs_evaluations_on_target_id_and_target_type", using: :btree

  create_table "rs_reputation_messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.float    "weight",      default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], name: "index_rs_reputation_messages_on_receiver_id_and_sender", unique: true, using: :btree
  add_index "rs_reputation_messages", ["receiver_id"], name: "index_rs_reputation_messages_on_receiver_id", using: :btree
  add_index "rs_reputation_messages", ["sender_id", "sender_type"], name: "index_rs_reputation_messages_on_sender_id_and_sender_type", using: :btree

  create_table "rs_reputations", force: :cascade do |t|
    t.string   "reputation_name"
    t.float    "value",           default: 0.0
    t.string   "aggregated_by"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
  end

  add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], name: "index_rs_reputations_on_reputation_name_and_target", unique: true, using: :btree
  add_index "rs_reputations", ["reputation_name"], name: "index_rs_reputations_on_reputation_name", using: :btree
  add_index "rs_reputations", ["target_id", "target_type"], name: "index_rs_reputations_on_target_id_and_target_type", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.string   "title"
    t.integer  "sequential_id"
    t.string   "status"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "begin_at"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issues_count",  default: 0,     null: false
    t.jsonb    "statuses",      default: []
    t.boolean  "archived",      default: false
  end

  add_index "sprints", ["project_id"], name: "index_sprints_on_project_id", using: :btree
  add_index "sprints", ["user_id"], name: "index_sprints_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                       default: "",   null: false
    t.string   "encrypted_password",          default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",             default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "notification_level"
    t.boolean  "mention_email_enabled",       default: true
    t.boolean  "participating_email_enabled", default: true
    t.boolean  "watch_email_enabled",         default: true
    t.string   "phone"
    t.string   "url"
    t.string   "github"
    t.string   "linkedin"
    t.string   "facebook"
    t.string   "twitter"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_channels", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_read_floor", default: 0
  end

  add_index "users_channels", ["channel_id"], name: "index_users_channels_on_channel_id", using: :btree
  add_index "users_channels", ["user_id"], name: "index_users_channels_on_user_id", using: :btree

  create_table "users_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_groups", ["group_id"], name: "index_users_groups_on_group_id", using: :btree
  add_index "users_groups", ["user_id"], name: "index_users_groups_on_user_id", using: :btree

  create_table "users_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notification_level"
    t.integer  "project_role_id"
  end

  add_index "users_projects", ["project_id"], name: "index_users_projects_on_project_id", using: :btree
  add_index "users_projects", ["project_role_id"], name: "index_users_projects_on_project_role_id", using: :btree
  add_index "users_projects", ["user_id"], name: "index_users_projects_on_user_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
