Rails.application.routes.draw do
  # Letter Opener Web routes for development
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Devise routes for authentication
  devise_for :users

  # Root path
  root "home#index"

  # Stadium routes
  resources :stadia do
    resources :reviews, only: [ :new, :create ]
    resources :bookings, only: [ :new, :create ]
  end

  # Booking routes
  resources :bookings do
    resources :payments, only: [ :new, :create, :show ]
    member do
      get :cancel
      patch :cancel
      patch :complete
      get "payment/success", to: "payments#stripe_success", as: :payment_success
      get "payment/cancel", to: "payments#stripe_cancel", as: :payment_cancel
    end
  end

  # Review routes
  resources :reviews, except: [ :index, :show, :new, :create ]

  # Payment routes
  resources :payments, only: [ :show ]

  # User profile routes
  resource :profile, only: [ :show, :edit, :update ]

  # Admin namespace for admin-only controllers
  namespace :admin do
    resources :users
    resources :stadia
    resources :bookings
    resources :payments
    resources :reviews

    # Admin dashboard
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"
  end

  # Email test routes (development only)
  if Rails.env.development?
    get "/email_test", to: "home#email_test"
    post "/send_test_email", to: "email_test#send_test_email"
  end

  # Webhook routes
  post "/webhooks/stripe", to: "webhooks#stripe"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
