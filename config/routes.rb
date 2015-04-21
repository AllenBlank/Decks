Rails.application.routes.draw do

  root 'searches#new'
  get 'about', to: 'static_pages#about', as: 'about'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'signin/facebook', to: redirect('auth/facebook'), as: 'facebook_signin'
  get 'signin/google', to: redirect('auth/google_oauth2'), as: 'google_signin'
  
  resources :cards, only: [:show] 
  resources :users, only: [:show]
  resources :expansions, only: [:index, :show]
  
  resources :decks, only: [:show, :new, :create, :update, :edit, :destroy]
  get '/users/:user_id/decks', to: 'decks#index', as: 'decks_index'
  
  resources :synergies, only: [:create]
  get '/decks/:deck_id/synergies', to: 'synergies#index'
  delete '/synergies', to: 'synergies#destroy'
  
  resources :searches, only: [:new, :create, :update, :show, :destroy] do
    get :autocomplete_card_name, :on => :collection
  end
  get '/users/:user_id/searches', to: 'searches#index', as: 'searches_index'

end
