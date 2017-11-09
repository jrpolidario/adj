Rails.application.routes.draw do
  resources :players
  constraints format: 'html' do
    match '*path', to: 'games#index', via: :all
  end

  constraints format: 'json' do
    resources :games
  end

  root 'games#index'
end
