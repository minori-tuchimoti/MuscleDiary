Rails.application.routes.draw do
  devise_for :users

  get '/homes', to: 'homes#top'
  get '/home/about', to: 'homes#about', as: 'about'
  root "homes#top"
  get '/users/:id', to: 'users#show', as: 'user'
  delete '/users/:id/cancel', to: 'users#cancel', as: 'cancel_user'
  resources :users
  resources :muscles
  get "/" => "users#login_form"
  post "/login" => "users#login"
  get "/new" => "users#new"
  post "/users/create" => "users#create"
  get "/edit/:id" => "users#edit"
  post "/users/update/:id" => "users#update"
  post "/logout" => "users#logout"
  
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
