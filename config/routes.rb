Moneko::Application.routes.draw do
  devise_for :users
  resources :offers
  resources :orders
  resources :users do
    resources :jobs
    resources :tasks
  end

  root to: "users#show"
end
