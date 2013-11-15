Moneko::Application.routes.draw do
  devise_for :users
  resources :offers
  resources :orders
  resources :users do
    resources :reports
  end

  root to: "offers#index"  
end
