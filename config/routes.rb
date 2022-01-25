Rails.application.routes.draw do
  devise_for :users
  resources :events, only: %i[index show]
  root 'pages#home'
end
