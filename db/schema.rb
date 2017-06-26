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

ActiveRecord::Schema.define(version: 20170618072018) do

  create_table "entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_type"
    t.string   "eng_word"
    t.string   "jpn_word"
    t.text     "description", limit: 65535
    t.string   "youtube_url"
    t.string   "site_url"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "mastered_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.boolean  "master_flag"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["entry_id"], name: "index_mastered_entries_on_entry_id", using: :btree
    t.index ["user_id", "entry_id"], name: "index_mastered_entries_on_user_id_and_entry_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_mastered_entries_on_user_id", using: :btree
  end

  create_table "tested_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_id"
    t.integer  "entry_id"
    t.boolean  "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_tested_entries_on_entry_id", using: :btree
    t.index ["test_id", "entry_id"], name: "index_tested_entries_on_test_id_and_entry_id", unique: true, using: :btree
    t.index ["test_id"], name: "index_tested_entries_on_test_id", using: :btree
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "test_date"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tests_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "mastered_entries", "entries"
  add_foreign_key "mastered_entries", "users"
  add_foreign_key "tested_entries", "entries"
  add_foreign_key "tested_entries", "tests"
  add_foreign_key "tests", "users"
end
