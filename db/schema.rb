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

ActiveRecord::Schema.define(version: 20150319232853) do

  create_table "cards", force: true do |t|
    t.text     "layout"
    t.text     "card_type"
    t.text     "types"
    t.text     "colors"
    t.text     "name"
    t.text     "rarity"
    t.integer  "cmc"
    t.text     "mana_cost"
    t.text     "text"
    t.text     "flavor"
    t.text     "artist"
    t.text     "rulings"
    t.text     "legalities"
    t.text     "number"
    t.text     "foreign_names"
    t.text     "source"
    t.text     "image_name"
    t.text     "printings"
    t.text     "release_date"
    t.text     "subtypes"
    t.text     "power"
    t.text     "toughness"
    t.text     "names"
    t.text     "supertypes"
    t.integer  "multiverseid"
    t.text     "original_type"
    t.text     "original_text"
    t.text     "variations"
    t.boolean  "reserved"
    t.integer  "loyalty"
    t.text     "border"
    t.text     "watermark"
    t.boolean  "timeshifted"
    t.boolean  "starter"
    t.integer  "hand"
    t.integer  "life"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expansion_id"
  end

  add_index "cards", ["expansion_id"], name: "index_cards_on_expansion_id"

  create_table "expansions", force: true do |t|
    t.text     "name"
    t.text     "code"
    t.text     "magic_rarities_codes"
    t.text     "release_date"
    t.text     "border"
    t.text     "expansion_type"
    t.text     "old_code"
    t.text     "gatherer_code"
    t.text     "block"
    t.text     "booster"
    t.boolean  "online_only"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
