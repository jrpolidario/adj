Rails.application.routes.draw do
  scope constraints: -> (request) { request.format == :json } do
    resources :sessions, only: [] do
      get :me, on: :collection
    end

    resources :games do
      resources :games_players, shallow: true
    end

    resources :players do
      resources :games_players, shallow: true
    end

    resources :cards
    resources :categories
  end

  scope constraints: -> (request) { request.format == :html } do
    match '*path', to: 'games#index', via: :all
  end

  root 'games#index'
end
