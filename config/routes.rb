Rails.application.routes.draw do
  resources :decks

  root 'static_pages#home'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'signin/facebook', to: redirect('auth/facebook'), as: 'facebook_signin'
  get 'signin/google', to: redirect('auth/google_oauth2'), as: 'google_signin'
  
  resources :static_pages do
    get :autocomplete_card_name, :on => :collection
  end
  
  resources :cards, only: [:index, :show]
  resources :expansions, only: [:index, :show]

end
