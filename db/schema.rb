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

ActiveRecord::Schema.define(version: 20150315183708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cycles", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "user_id"
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "cycles", ["item_type", "item_id"], name: "index_cycles_on_item_type_and_item_id", using: :btree
  add_index "cycles", ["user_id"], name: "index_cycles_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "layers", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "user_id"
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "layers", ["item_type", "item_id"], name: "index_layers_on_item_type_and_item_id", using: :btree
  add_index "layers", ["user_id"], name: "index_layers_on_user_id", using: :btree

  create_table "node_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   limit: 8, null: false
    t.integer "descendant_id", limit: 8, null: false
    t.integer "generations",             null: false
  end

  add_index "node_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "index_nodes_on_anc_and_desc_and_gens", unique: true, using: :btree
  add_index "node_hierarchies", ["descendant_id"], name: "index_nodes_on_desc", using: :btree

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",  limit: 8
  end

  add_index "nodes", ["parent_id", "user_id", "name"], name: "index_nodes_on_parent_id_and_user_id_and_name", unique: true, using: :btree
  add_index "nodes", ["parent_id"], name: "index_nodes_on_parent_id", using: :btree
  add_index "nodes", ["user_id"], name: "index_nodes_on_user_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                null: false
    t.integer  "node_id",      limit: 8, null: false
    t.text     "content_html"
  end

  add_index "notes", ["node_id"], name: "index_notes_on_node_id", using: :btree
  add_index "notes", ["user_id", "node_id", "name"], name: "index_notes_on_user_id_and_node_id_and_name", unique: true, using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "rings", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "user_id"
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "rings", ["item_type", "item_id"], name: "index_rings_on_item_type_and_item_id", using: :btree
  add_index "rings", ["user_id"], name: "index_rings_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",                        null: false
    t.string   "email",                           null: false
    t.string   "crypted_password",                null: false
    t.string   "salt",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
