require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', passwords: 'passwords' }

  resources :events, only: [:index, :show] do
    resources :bookings, only: [:new, :create] do
      collection do
        post :create_payment_intent
      end
    end
  end
  resources :orders, only: [] do
    member do
      get :pay
    end
  end
  resources :people, only: [] do
    collection do
      get :me
    end
  end

  resources :calendars, only: [:show]
  get 'facilities', to: 'pages#facilities'

  namespace :admin do
    root to: 'admin#index'
    resources :people, only: [:index, :show] do
      collection do
        get :metrics
        resources :plans, only: [:index, :edit, :update]
        resources :fobs, only: [:index]
      end
    end
    scope :place do
      resources :areas
    end
    scope :program do
      resources :event_sessions, only: [:index, :show]
      resources :open_times, only: [:index] do
        collection do
          post :bulk_update
          post :update_managers
          get :create_month
        end
      end
    end
    scope :public do
      resources :images, only: [:index]
    end
  end

  namespace :api do
    resources :event_sessions, only: [] do
      collection do
        get :next
      end
    end
    resources :fobs, only: [] do
      member do
        post :touch
      end
    end
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'pages#home'
end
