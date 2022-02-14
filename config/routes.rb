Rails.application.routes.draw do
  devise_for :users
  resources :events, only: [:index, :show]

  namespace :admin do
    root to: 'admin#index'
    resources :people, only: [:index, :show]
    resources :events, only: [:index]
    resources :event_sessions, only: [:show]
  end

  root 'pages#home'
end
