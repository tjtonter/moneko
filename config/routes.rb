Moneko::Application.routes.draw do
  resources :offers

  root to: "offers#index"  
end
