Rails.application.routes.draw do
  root 'static_pages#home'
  
  resources :static_pages do
    get :autocomplete_card_name, :on => :collection
  end
  
  
  resources :cards 
  resources :expansions

end
