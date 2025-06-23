Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  # Devise routes for authentication
  devise_for :users
  
  # Root path
  root "home#index"
  
  # Stadium routes
  resources :stadia do
    resources :reviews, only: [:new, :create]
    resources :bookings, only: [:new, :create]
  end
  
  # Booking routes
  resources :bookings do
    resources :payments, only: [:new, :create, :show]
    member do
      patch :cancel
      patch :complete
    end
  end
  
  # Review routes
  resources :reviews, except: [:index, :show, :new, :create]
  
  # Payment routes
  resources :payments, only: [:show]
  
  # User profile routes
  resource :profile, only: [:show, :edit, :update]
  
  # Admin namespace for admin-only controllers
  namespace :admin do
    resources :users
    resources :stadia
    resources :bookings
    resources :payments
    resources :reviews
    
    # Admin dashboard
    get 'dashboard', to: 'dashboard#index'
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
