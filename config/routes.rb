Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  resources :subjects
  resources :users, only: [:show]
end
