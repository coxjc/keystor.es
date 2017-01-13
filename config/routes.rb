Rails.application.routes.draw do
  root :to => 'users#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :keystores
  resources :users
  get "/pages/:page" => "pages#show"
end
