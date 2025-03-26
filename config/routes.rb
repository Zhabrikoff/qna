# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]

  root to: 'questions#index'
end
