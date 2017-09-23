Rails.application.routes.draw do
  root "subjects#index"
  devise_for :users
  resources :subjects
  scope "users" do
    get "fetch_users", to: "users#fetch_users"
    post "add_friend/:id", to: "users#add_friend", as: "add_friend"
    delete "remove_friend/:id", to: "users#remove_friend", as: "remove_friend"
  end

  resources :users, only: [:show, :index] do
    resources :lessons, only: [:create, :new, :index, :destroy]
  end

  get :fetch_lessons, to: "lessons#fetch_lessons", as: "fetch_lessons"
  post "lessons/:id/accept_invite", to: "lessons#accept_invite", as: "accept_lesson_invite"
  delete "lessons/:id/decline_invite", to: "lessons#decline_invite", as: "decline_lesson_invite"

  post "add_subject/:id", to: "users#add_subject", as: "add_subject"
  delete "remove_subject/:id", to: "users#remove_subject", as: "remove_subject"

  resources :chatrooms, only: [:index, :show] do
    post "add_participant/:user_id", to: "chatrooms#add_participant", as: "add_participant"
    get "fetch_users", to: "chatrooms#fetch_users", as: "fetch_users"
  end
  post "chatrooms/:user_id", to: "chatrooms#create", as: "new_chatroom"

  get "chatrooms/video_token/:chatroom_id", to: "chatrooms#generate_video_token"

  mount ActionCable.server => '/cable'
end
