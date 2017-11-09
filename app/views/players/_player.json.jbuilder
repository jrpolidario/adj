json.extract! player, :id, :score, :name, :game_id, :created_at, :updated_at
json.url player_url(player, format: :json)
