Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  # We can only make and delete posts just like TWITTER
  resources :microposts, only: [:create, :destroy]
  # For follow and unfollow
  resources :relationships, only: [:create, :destroy]
  root 'static_pages#home'

  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  # Likes
  resources :microposts do
    member do
      post 'like'
    end
  end
  
end
