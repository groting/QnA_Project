Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'new_email', to: 'omniauth_callbacks#new_email', as: :new_user_email
  end

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
