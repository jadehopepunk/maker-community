require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :events, only: [:index, :show]

  namespace :admin do
    root to: 'admin#index'
    resources :people, only: [:index, :show] do
      collection do
        get :metrics
      end
    end
    scope :program do
      resources :event_sessions, only: [:index, :show]
      resources :open_times, only: [:index] do
        collection do
          post :bulk_update
          get :create_month
        end
      end
    end
    scope :public do
      resources :images, only: [:index]
    end
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'pages#home'
end
