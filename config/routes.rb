Moneko::Application.routes.draw do
  devise_for :users
  resources :offers

  root to: "offers#index"  
end
