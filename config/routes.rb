Moneko::Application.routes.draw do
  get "occurrences/index"
  devise_for :users
  resources :offers
  resources :orders
  resources :occurrences, only: [:index]
  resources :users do
    resources :jobs
    resources :tasks
  end

  root to: "users#show"
end
