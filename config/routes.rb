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
    resources :events, only: [:index]
    resources :event_sessions, only: [:index, :show]
    resources :images, only: [:index]
  end

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'pages#home'
end
