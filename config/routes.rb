Moneko::Application.routes.draw do
  devise_for :users
  resources :offers, :users

  root to: "offers#index"  
end
