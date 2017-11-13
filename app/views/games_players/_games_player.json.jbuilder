json.extract! games_player, :id, :game_id, :player_id, :selected_card_id, :created_at, :updated_at
json.url games_player_url(games_player, format: :json)
