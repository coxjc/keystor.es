Rails.application.routes.draw do
  root :to => 'pages#show', page: 'home'

  get "/pages/:page" => "pages#show"

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :keystores
  resources :users

end
