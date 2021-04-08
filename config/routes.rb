Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :users, only: %i[] do
    get :badges, on: :member
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :votable  do
    resources :answers, concerns: :votable , shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :files, only: [:destroy]

  resources :links, only: [:destroy]

  mount ActionCable.server => '/cable'
end
