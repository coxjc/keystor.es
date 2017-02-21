Rails.application.routes.draw do
  default_url_options :host => 'localhost:3000'
  root :to => 'pages#show', page: 'home'

  get '/pages/:page' => 'pages#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :keystores, except: [:edit, :update]
  resources :users do
    member do
      get :confirm_email
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
  get '/charges/edit', to: 'charges#edit'
  post '/charges/edit', to: 'charges#update'
  post 'charges/update_sub' => 'charges#update_sub'
  resources :charges, except: [:edit, :update]

end
