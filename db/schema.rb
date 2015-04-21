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

ActiveRecord::Schema.define(version: 20150421181205) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.text     "color_id"
    t.text     "formats"
  end

  add_index "cards", ["expansion_id"], name: "index_cards_on_expansion_id", using: :btree
  add_index "cards", ["name"], name: "index_cards_on_name", using: :btree
  add_index "cards", ["newest"], name: "index_cards_on_newest", using: :btree

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

  create_table "piles", force: true do |t|
    t.integer  "card_id"
    t.integer  "deck_id"
    t.integer  "count"
    t.string   "board"
    t.text     "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "piles", ["card_id"], name: "index_piles_on_card_id", using: :btree
  add_index "piles", ["deck_id"], name: "index_piles_on_deck_id", using: :btree

  create_table "searches", force: true do |t|
    t.text     "parameters"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "name_field"
    t.text     "text_field"
    t.text     "type_field"
    t.text     "format_field"
    t.text     "advanced_field"
    t.text     "colors"
    t.boolean  "exact_field"
    t.string   "sort_by_field"
    t.string   "sort_direction_field"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "synergies", force: true do |t|
    t.integer  "pile_id"
    t.integer  "compliment_id"
    t.float    "power"
    t.string   "type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "synergies", ["compliment_id"], name: "index_synergies_on_compliment_id", using: :btree
  add_index "synergies", ["pile_id", "compliment_id"], name: "index_synergies_on_pile_id_and_compliment_id", unique: true, using: :btree
  add_index "synergies", ["pile_id"], name: "index_synergies_on_pile_id", using: :btree

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
