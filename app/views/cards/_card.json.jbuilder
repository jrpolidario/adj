json.extract! card, :id, :category_id, :name, :image, :score, :created_at, :updated_at
json.url card_url(card, format: :json)
