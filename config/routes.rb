Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    patch :like, on: :member
    patch :dislike, on: :member
    patch :clear_vote, on: :member
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions do
    concerns :votable, :commentable
    resources :answers, shallow: true do
      patch :select_best, on: :member
      concerns :votable, :commentable
    end
  end

  resources :attachments, only: [:destroy]
  resources :comments, only: [:destroy]
  
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
