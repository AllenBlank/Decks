Rails.application.routes.draw do
  root 'static_pages#home'
  
  resources :static_pages do
    get :autocomplete_card_name, :on => :collection
  end
  
  
  resources :cards, only: [:index, :show]
  
  resources :expansions, only: [:index, :show]

end
