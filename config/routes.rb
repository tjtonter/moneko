Moneko::Application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do 
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end
  resources :offers
  resources :orders
  resources :users do
    resources :jobs
    resources :tasks
  end

  root to: "users#show"
end
