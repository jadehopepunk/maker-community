Rails.application.routes.draw do
  devise_for :users
  resources :events, only: [:index, :show]

  namespace :admin do
    resources :people, only: [:index, :show]
  end

  root 'pages#home'
end
