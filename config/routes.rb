Rails.application.routes.draw do
  devise_for :users


  devise_scope :admin do
    authenticated :admin do
      root to: 'admin/dashboards#index', as: :authenticated_admin_root
    end
  end
  
  
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    resources :users, only: [:show, :edit, :update, :destroy]
    resources :dashboards, only: [:index]
  end

  scope module: :public do
    resources :muscles, only: [:new, :create, :index, :show, :destroy] do
      resources :post_comments, only: [:create, :destroy]
    end
    
    get '/' => 'homes#top'
    root to: 'homes#top', as: 'top_root'
    get 'homes/about', to: 'homes#about', as: :public_about 
    resources :muscles, only: [:new, :create, :index, :show, :destroy]
    resource :favorites, only: [:create, :destroy]
    resources :users, only: [:show, :edit, :update]
  
    get '/homes', to: 'homes#top'
    get '/home/about', to: 'homes#about', as: 'about'
    root "homes#top"
    get '/users/:id', to: 'users#show', as: 'show_user' 
    delete '/users/:id/cancel', to: 'users#cancel', as: 'cancel_user'
    get '/search', to: 'searches#search'
    resources :users
    resources :muscles
    get "/" => "users#login_form", as: 'users_login' 
    post "/login" => "users#login"
    get "/new" => "users#new"
    post "/users/create" => "users#create"
    get "/edit/:id" => "users#edit"
    post "/users/update/:id" => "users#update"
    post "/logout" => "users#logout"

  end
  
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
