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

ActiveRecord::Schema.define(version: 20160630175440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "metros", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metros", ["name"], name: "index_metros_on_name", using: :btree

  create_table "misspelled_domains", force: :cascade do |t|
    t.text     "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "misspelled_domains", ["domain"], name: "index_misspelled_domains_on_domain", using: :btree

  create_table "terms", force: :cascade do |t|
  end

  create_table "top_level_domains", force: :cascade do |t|
    t.text     "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "top_level_domains", ["domain"], name: "index_top_level_domains_on_domain", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "name",                                   null: false
    t.integer  "type",                                   null: false
    t.text     "phone"
    t.text     "zip"
    t.integer  "zip_radius"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zipcodes", force: :cascade do |t|
    t.text     "zip"
    t.decimal  "lat"
    t.decimal  "long"
    t.text     "city"
    t.text     "state"
    t.text     "county"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "metro_id"
  end

  add_index "zipcodes", ["metro_id"], name: "index_zipcodes_on_metro_id", using: :btree

end
