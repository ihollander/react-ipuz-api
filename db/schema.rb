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

ActiveRecord::Schema.define(version: 2019_01_23_152527) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "host_id"
    t.bigint "guest_id"
    t.string "puzzle"
    t.integer "timer"
    t.float "solved"
    t.boolean "active"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "host_active", default: false
    t.boolean "guest_active", default: false
    t.index ["guest_id"], name: "index_games_on_guest_id"
    t.index ["host_id"], name: "index_games_on_host_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_messages_on_game_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
  end

  add_foreign_key "games", "users", column: "guest_id"
  add_foreign_key "games", "users", column: "host_id"
  add_foreign_key "messages", "games"
  add_foreign_key "messages", "users"
end
