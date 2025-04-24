Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations'
  }

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:destroy]
  end
  

  namespace :public do
    resources :muscles, only: [] do
      post ':id', to: 'muscles#some_action', as: 'muscle_action'
      resources :post_comments, only: [:destroy]
      resource :favorites, only: [:create, :destroy] 
    end
    resources :users do
      get 'liked_posts', on: :member
    end
  end

  namespace :admin do
    resources :users, only: [:show, :edit, :update, :destroy]
    resources :dashboards, only: [:index]
  end

  scope module: :public do
    root to: 'homes#top'
    get 'homes/about', to: 'homes#about', as: 'about'
    resources :muscles, only: [:new, :create, :edit, :update, :index, :show, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update, :cancel, :destroy, :liked_]
  end
  

    get '/' => 'homes#top'

    
    get '/users/:id', to: 'users#show', as: 'show_user' 
    delete '/users/:id/cancel', to: 'users#cancel', as: 'cancel_user'
    get '/search', to: 'searches#search'
  
    post "/login" => "users#login"
    get "/new" => "users#new"
    post "/users/create" => "users#create"
    get "/edit/:id" => "users#edit"
    post "/users/update/:id" => "users#update"
    post "/logout" => "users#logout"
  
  #ゲストログイン　ここから
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  #ここまで

  #フォロー、フォロワー機能　ここから
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  	get "followings" => "relationships#followings", as: "followings"
  	get "followers" => "relationships#followers", as: "followers"
  end
  #ここまで
end
