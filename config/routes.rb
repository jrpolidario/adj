Rails.application.routes.draw do
  constraints format: 'json' do
    resources :games
    resources :players
  end
  
  constraints format: 'html' do
    match '*path', to: 'games#index', via: :all
  end

  root 'games#index'
end
