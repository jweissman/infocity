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

ActiveRecord::Schema.define(version: 20170522154436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cartograms", force: :cascade do |t|
    t.integer  "structure",  default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "management_keys", force: :cascade do |t|
    t.integer  "space_id"
    t.uuid     "value"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["space_id"], name: "index_management_keys_on_space_id", using: :btree
  end

  create_table "spaces", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "cartogram_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["cartogram_id"], name: "index_spaces_on_cartogram_id", using: :btree
  end

  add_foreign_key "management_keys", "spaces"
  add_foreign_key "spaces", "cartograms"
end
