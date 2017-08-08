Rails.application.routes.draw do
  root "users#index"
  devise_for :users
  resources :subjects
  resources :users, only: [:show]
  post "add_subject/:id", to: "users#add_subject"
end
