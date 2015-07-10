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

ActiveRecord::Schema.define(version: 20150710003637) do

  create_table "actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "game_id"
    t.integer  "affect"
  end

  add_index "actions", ["affect"], name: "index_actions_on_affect"
  add_index "actions", ["game_id"], name: "index_actions_on_game_id"

  create_table "cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "action_id"
    t.string   "suit"
    t.string   "rank"
  end

  add_index "cards", ["action_id"], name: "index_cards_on_action_id"
  add_index "cards", ["rank"], name: "index_cards_on_rank"
  add_index "cards", ["suit"], name: "index_cards_on_suit"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "pending",    default: true
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "action_id"
    t.integer  "game_id"
  end

  add_index "players", ["action_id"], name: "index_players_on_action_id"
  add_index "players", ["game_id"], name: "index_players_on_game_id"

end
