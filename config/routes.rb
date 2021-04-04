Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :users, only: %i[] do
    get :badges, on: :member
  end

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :files, only: [:destroy]

  resources :links, only: [:destroy]
end
