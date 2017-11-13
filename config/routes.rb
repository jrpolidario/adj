Rails.application.routes.draw do
  scope constraints: -> (request) { request.format == :json } do
    resources :games
    resources :players
    resources :games_players
    resources :cards
    resources :categories
  end

  scope constraints: -> (request) { request.format == :html } do
    match '*path', to: 'games#index', via: :all
  end

  root 'games#index'
end
