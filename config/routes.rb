Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    patch :like, on: :member
    patch :dislike, on: :member
    patch :clear_vote, on: :member
  end

  resources :questions do
    concerns :votable
    resources :answers, shallow: true do
      patch :select_best, on: :member
      concerns :votable
    end
  end

  resources :attachments, only: [:destroy]
  
  root to: "questions#index"

end
