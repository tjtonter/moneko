Moneko::Application.routes.draw do
  constraints(:host => /176.9.169.237/) do 
    match "/(*path)" => redirect {|params, req| "http://static.237.169.9.176.clients.your-server.de/#{params[:path]}"}, :via => [:get, :post]
  end

  root to: 'homepages#front'
  get '/' => 'homepages#front'

  devise_for :users, :skip => [:registrations],
    :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
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

end
