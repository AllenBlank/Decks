Rails.application.routes.draw do

  root 'static_pages#home'
  get 'about', to: 'static_pages#about', as: 'about'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'signin/facebook', to: redirect('auth/facebook'), as: 'facebook_signin'
  get 'signin/google', to: redirect('auth/google_oauth2'), as: 'google_signin'
  
  resources :decks
  
  resources :cards, only: [:index, :show] do
    get :autocomplete_card_name, :on => :collection
  end
  
  resources :expansions, only: [:index, :show]
  
  resources :synergies, only: [:create]
  get '/decks/:deck_id/synergies', to: 'synergies#index'
  delete '/synergies', to: 'synergies#delete'

end
