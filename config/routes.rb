Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations'
  }

  scope as: 'admin' do
    devise_scope :admin do
      authenticated :admin do
        root to: 'admin/dashboards#index', as: :authenticated_admin_root
      end
    end
  end
  

  namespace :public do
    resources :muscles, only: [] do
      post ':id', to: 'muscles#some_action', as: 'muscle_action'
    end
    resources :users  
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
    
    get "/" => "users#login_form", as: 'users_login' 
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
