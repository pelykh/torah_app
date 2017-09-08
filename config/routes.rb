Rails.application.routes.draw do
  root "subjects#index"
  devise_for :users
  resources :subjects
  scope "users" do
    get "fetch_users", to: "users#fetch_users"
    post "add_friend/:id", to: "users#add_friend", as: "add_friend"
    delete "remove_friend/:id", to: "users#remove_friend", as: "remove_friend"
  end

  resources :users, only: [:show, :index]

  post "add_subject/:id", to: "users#add_subject", as: "add_subject"
  delete "remove_subject/:id", to: "users#remove_subject", as: "remove_subject"

  resources :chatrooms, only: [:index, :show]
  post "chatrooms/:user_id", to: "chatrooms#create", as: "new_chatroom"

  get "chatrooms/video_token/:chatroom_id", to: "chatrooms#generate_video_token"

  mount ActionCable.server => '/cable'
end
