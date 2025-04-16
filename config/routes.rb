# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: %i[create update destroy]
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
