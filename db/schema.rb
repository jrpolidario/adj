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

ActiveRecord::Schema.define(version: 20171129175810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", null: false
    t.string "image_source_url"
    t.index ["category_id"], name: "index_cards_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["player_id"], name: "index_comments_on_player_id"
    t.index ["updated_at"], name: "index_comments_on_updated_at"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["game_id"], name: "index_deck_cards_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_finished", default: false, null: false
    t.string "password_digest"
    t.boolean "is_started", default: false, null: false
    t.integer "current_turn_games_player_id"
    t.integer "games_players_turn_sequence", default: [], array: true
    t.index ["created_at"], name: "index_games_on_created_at"
    t.index ["is_finished"], name: "index_games_on_is_finished"
    t.index ["is_started"], name: "index_games_on_is_started"
    t.index ["updated_at"], name: "index_games_on_updated_at"
  end

  create_table "games_players", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "player_id"
    t.integer "selected_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0, null: false
    t.boolean "is_ready", default: false, null: false
    t.integer "team"
    t.index ["game_id"], name: "index_games_players_on_game_id"
    t.index ["player_id"], name: "index_games_players_on_player_id"
    t.index ["selected_card_id"], name: "index_games_players_on_selected_card_id"
  end

  create_table "live_record_updates", id: :serial, force: :cascade do |t|
    t.string "recordable_type"
    t.integer "recordable_id"
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_live_record_updates_on_created_at"
    t.index ["recordable_type", "recordable_id"], name: "index_live_record_updates_on_recordable_type_and_recordable_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "score"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_players_on_created_at"
    t.index ["updated_at"], name: "index_players_on_updated_at"
  end

  create_table "selectable_cards", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", null: false
    t.boolean "is_selected", default: false, null: false
    t.integer "seconds_left", null: false
    t.boolean "is_bomb", default: false, null: false
    t.boolean "is_question", default: false, null: false
    t.integer "score", null: false
    t.boolean "is_time_is_up", default: false, null: false
    t.integer "team_winner"
    t.boolean "is_done", default: false, null: false
    t.integer "seconds_duration"
    t.index ["card_id"], name: "index_selectable_cards_on_card_id"
    t.index ["game_id"], name: "index_selectable_cards_on_game_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_admin"], name: "index_users_on_is_admin"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "categories"
  add_foreign_key "comments", "players"
  add_foreign_key "deck_cards", "cards"
  add_foreign_key "deck_cards", "games"
  add_foreign_key "games_players", "games"
  add_foreign_key "games_players", "players"
  add_foreign_key "selectable_cards", "cards"
  add_foreign_key "selectable_cards", "games"
end
