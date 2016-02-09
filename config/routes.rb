Moneko::Application.routes.draw do
  root to: 'homepages#front'
  get '/' => 'homepages#front'
  get '/palvelut' => 'homepages#services'
  get '/yhteystiedot' => 'homepages#contact'

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
