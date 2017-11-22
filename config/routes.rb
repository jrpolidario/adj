Rails.application.routes.draw do
  scope path: 'admin' do
    devise_for :users
    resources :cards
    resources :categories
  end

  scope constraints: -> (request) { request.format == :json } do
    resources :sessions, only: [] do
      get :me, on: :collection
    end

    resources :games do
      resources :games_players, shallow: true
      resources :selectable_cards, shallow: true do
        post 'take_from_deck', on: :collection
      end
    end

    resources :players do
      resources :games_players, shallow: true
    end

    resources :comments
  end

  scope constraints: -> (request) { request.format == :html } do
    match '*path', to: 'games#index', via: :all
  end

  root 'games#index'
end
