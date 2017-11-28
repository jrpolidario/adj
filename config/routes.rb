Rails.application.routes.draw do
  constraints(:host => /^www\./) do
    match "(*x)" => redirect { |params, request|
      URI.parse(request.url).tap {|url| url.host.sub!('www.', '') }.to_s
    }, via: [:get, :post]
  end
  
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
      resources :selectable_cards, shallow: true
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
