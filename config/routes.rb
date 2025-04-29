# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda(&:admin?) do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

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
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  get '/search', to: 'search#search'

  mount ActionCable.server => '/cable'
end
