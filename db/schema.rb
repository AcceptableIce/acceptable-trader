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

ActiveRecord::Schema.define(version: 20160517221244) do

  create_table "bgg_item_data", force: :cascade do |t|
    t.string   "item_type",        limit: 255
    t.string   "image",            limit: 255
    t.string   "thumbnail",        limit: 255
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.integer  "year_published",   limit: 4
    t.integer  "min_players",      limit: 4
    t.integer  "max_players",      limit: 4
    t.integer  "playing_time",     limit: 4
    t.integer  "min_playing_time", limit: 4
    t.integer  "max_playing_time", limit: 4
    t.integer  "user_ratings",     limit: 4
    t.float    "average",          limit: 24
    t.float    "bayes",            limit: 24
    t.float    "stddev",           limit: 24
    t.float    "median",           limit: 24
    t.integer  "owned",            limit: 4
    t.integer  "trading",          limit: 4
    t.integer  "wanting",          limit: 4
    t.integer  "wishing",          limit: 4
    t.integer  "num_comments",     limit: 4
    t.integer  "num_weights",      limit: 4
    t.integer  "average_weight",   limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "bgg_item_data_ranks", force: :cascade do |t|
    t.integer  "bgg_item_data_id", limit: 4,   null: false
    t.string   "rank_type",        limit: 255
    t.string   "name",             limit: 255
    t.string   "friendly_name",    limit: 255
    t.integer  "value",            limit: 4
    t.float    "bayes",            limit: 24
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "bgg_item_data_ranks", ["bgg_item_data_id"], name: "index_bgg_item_data_ranks_on_bgg_item_data_id", using: :btree

  create_table "bgg_user_data", force: :cascade do |t|
    t.string  "name",            limit: 255
    t.string  "avatar",          limit: 255
    t.integer "year_registered", limit: 4
    t.string  "state",           limit: 255
    t.integer "trade_rating",    limit: 4
  end

  create_table "math_trade_items", force: :cascade do |t|
    t.integer  "bgg_item_id",   limit: 4,     default: -1,    null: false
    t.integer  "user_id",       limit: 4,                     null: false
    t.integer  "math_trade_id", limit: 4,                     null: false
    t.text     "description",   limit: 65535
    t.string   "alt_name",      limit: 255
    t.boolean  "did_trade",                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",      limit: 4
  end

  add_index "math_trade_items", ["math_trade_id"], name: "index_math_trade_items_on_math_trade_id", using: :btree
  add_index "math_trade_items", ["user_id"], name: "index_math_trade_items_on_user_id", using: :btree

  create_table "math_trade_want_confirmations", force: :cascade do |t|
    t.integer  "math_trade_id", limit: 4, null: false
    t.integer  "user_id",       limit: 4, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "math_trade_want_confirmations", ["math_trade_id"], name: "index_math_trade_want_confirmations_on_math_trade_id", using: :btree
  add_index "math_trade_want_confirmations", ["user_id"], name: "index_math_trade_want_confirmations_on_user_id", using: :btree

  create_table "math_trade_want_items", force: :cascade do |t|
    t.integer  "math_trade_want_id", limit: 4, null: false
    t.integer  "math_trade_item_id", limit: 4, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "math_trade_want_items", ["math_trade_item_id"], name: "index_math_trade_want_items_on_math_trade_item_id", using: :btree
  add_index "math_trade_want_items", ["math_trade_want_id"], name: "index_math_trade_want_items_on_math_trade_want_id", using: :btree

  create_table "math_trade_wants", force: :cascade do |t|
    t.integer  "user_id",            limit: 4, null: false
    t.integer  "math_trade_id",      limit: 4, null: false
    t.integer  "math_trade_item_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "math_trade_wants", ["math_trade_id"], name: "index_math_trade_wants_on_math_trade_id", using: :btree
  add_index "math_trade_wants", ["math_trade_item_id"], name: "index_math_trade_wants_on_math_trade_item_id", using: :btree
  add_index "math_trade_wants", ["user_id"], name: "index_math_trade_wants_on_user_id", using: :btree

  create_table "math_trades", force: :cascade do |t|
    t.string   "name",              limit: 255,                      null: false
    t.integer  "moderator_id",      limit: 4,                        null: false
    t.text     "description",       limit: 65535
    t.integer  "status",            limit: 4,        default: 0,     null: false
    t.datetime "offer_deadline",                                     null: false
    t.datetime "wants_deadline",                                     null: false
    t.boolean  "shipping",                           default: false, null: false
    t.integer  "discussion_thread", limit: 4
    t.binary   "results_list",      limit: 16777215
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.datetime "deleted_at"
    t.datetime "finalized_at"
  end

  add_index "math_trades", ["deleted_at"], name: "index_math_trades_on_deleted_at", using: :btree
  add_index "math_trades", ["moderator_id"], name: "index_math_trades_on_moderator_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                         limit: 255, default: "",    null: false
    t.string   "encrypted_password",            limit: 255, default: "",    null: false
    t.string   "reset_password_token",          limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",            limit: 255
    t.string   "last_sign_in_ip",               limit: 255
    t.string   "bgg_account",                   limit: 255
    t.integer  "bgg_user_data_id",              limit: 4
    t.string   "bgg_account_verification_code", limit: 255
    t.boolean  "bgg_account_verified",                      default: false, null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "users", ["bgg_user_data_id"], name: "index_users_on_bgg_user_data_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "want_group_items", force: :cascade do |t|
    t.integer  "want_group_id",      limit: 4, null: false
    t.integer  "math_trade_item_id", limit: 4, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "want_group_items", ["math_trade_item_id"], name: "index_want_group_items_on_math_trade_item_id", using: :btree
  add_index "want_group_items", ["want_group_id"], name: "index_want_group_items_on_want_group_id", using: :btree

  create_table "want_group_links", force: :cascade do |t|
    t.integer  "want_group_id",      limit: 4, null: false
    t.integer  "math_trade_want_id", limit: 4, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "want_group_links", ["math_trade_want_id"], name: "index_want_group_links_on_math_trade_want_id", using: :btree
  add_index "want_group_links", ["want_group_id"], name: "index_want_group_links_on_want_group_id", using: :btree

  create_table "want_groups", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,   null: false
    t.integer  "math_trade_id", limit: 4,   null: false
    t.string   "name",          limit: 255, null: false
    t.string   "short_name",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "want_groups", ["math_trade_id"], name: "index_want_groups_on_math_trade_id", using: :btree
  add_index "want_groups", ["user_id"], name: "index_want_groups_on_user_id", using: :btree

  add_foreign_key "bgg_item_data_ranks", "bgg_item_data"
  add_foreign_key "math_trade_items", "math_trades"
  add_foreign_key "math_trade_items", "users"
  add_foreign_key "math_trade_want_confirmations", "math_trades"
  add_foreign_key "math_trade_want_confirmations", "users"
  add_foreign_key "math_trade_want_items", "math_trade_items"
  add_foreign_key "math_trade_want_items", "math_trade_wants"
  add_foreign_key "math_trade_wants", "math_trade_items"
  add_foreign_key "math_trade_wants", "math_trades"
  add_foreign_key "math_trade_wants", "users"
  add_foreign_key "math_trades", "users", column: "moderator_id"
  add_foreign_key "users", "bgg_user_data"
  add_foreign_key "want_group_items", "math_trade_items"
  add_foreign_key "want_group_items", "want_groups"
  add_foreign_key "want_group_links", "math_trade_wants"
  add_foreign_key "want_group_links", "want_groups"
  add_foreign_key "want_groups", "math_trades"
  add_foreign_key "want_groups", "users"
end
