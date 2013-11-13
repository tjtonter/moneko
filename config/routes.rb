Moneko::Application.routes.draw do
  devise_for :users
  resources :offers
  resources :orders
  resources :users

  root to: "offers#index"  
end
