Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post 'new_email', to: 'omniauth_callbacks#new_email', as: :new_user_email
  end

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
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
    resources :subscriptions, only: [:create]
    resources :answers, shallow: true do
      patch :select_best, on: :member
      concerns :votable, :commentable
    end
  end

  resource :search, only: :show

  resources :attachments, only: [:destroy]
  resources :comments, only: [:destroy]
  resources :subscriptions, only: [:destroy]
  
  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end