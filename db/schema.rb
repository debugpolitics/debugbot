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

ActiveRecord::Schema.define(version: 20161220024001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "task_completions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "task_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_completions_on_task_id", using: :btree
    t.index ["user_id"], name: "index_task_completions_on_user_id", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.text     "description",                  null: false
    t.boolean  "is_multi_use", default: false, null: false
    t.boolean  "has_expired",  default: true,  null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["has_expired"], name: "index_tasks_on_has_expired", using: :btree
    t.index ["is_multi_use"], name: "index_tasks_on_is_multi_use", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slack_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true, using: :btree
  end

  add_foreign_key "task_completions", "tasks", on_delete: :cascade
  add_foreign_key "task_completions", "users", on_delete: :cascade
end
