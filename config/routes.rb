Moneko::Application.routes.draw do
  devise_for :users
  resources :offers do
    resources :orders
  end

  resources :orders, only: [:index]
  resources :users

  root to: "offers#index"  
end
