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

ActiveRecord::Schema.define(version: 20150323213230) do

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
    t.integer  "multiverse_id"
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
    t.boolean  "newest",        default: true
    t.boolean  "uploaded"
  end

  add_index "cards", ["expansion_id"], name: "index_cards_on_expansion_id"
  add_index "cards", ["name"], name: "index_cards_on_name"
  add_index "cards", ["newest"], name: "index_cards_on_newest"

  create_table "cards_decks", id: false, force: true do |t|
    t.integer "card_id"
    t.integer "deck_id"
  end

  add_index "cards_decks", ["card_id"], name: "index_cards_decks_on_card_id"
  add_index "cards_decks", ["deck_id"], name: "index_cards_decks_on_deck_id"

  create_table "cards_sideboards", id: false, force: true do |t|
    t.integer "card_id"
    t.integer "sideboard_id"
  end

  add_index "cards_sideboards", ["card_id"], name: "index_cards_sideboards_on_card_id"
  add_index "cards_sideboards", ["sideboard_id"], name: "index_cards_sideboards_on_sideboard_id"

  create_table "decks", force: true do |t|
    t.integer  "user_id"
    t.string   "format"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "commander"
  end

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

  create_table "sideboards", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "deck_id"
  end

  add_index "sideboards", ["deck_id"], name: "index_sideboards_on_deck_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "admin"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
