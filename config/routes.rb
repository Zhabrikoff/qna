# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member

      delete :delete_file, on: :member
    end

    delete :delete_file, on: :member
  end

  root to: 'questions#index'
end
