Rails.application.routes.draw do
  devise_for :users
  resources :events, only: %i[index show]

  namespace :admin do
    resources :people, only: [:index]
  end

  root 'pages#home'
end
