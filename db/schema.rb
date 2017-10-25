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

ActiveRecord::Schema.define(version: 20171024221949) do

  create_table "games", force: :cascade do |t|
    t.integer  "player_num"
    t.integer  "room_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "joins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "role"
    t.boolean  "win"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "joins", ["game_id"], name: "index_joins_on_game_id"
  add_index "joins", ["user_id"], name: "index_joins_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "profile_img"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
