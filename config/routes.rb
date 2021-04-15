Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :cancel_vote
    end
  end

  root to: 'questions#index'

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true, concerns: %i[votable] do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: :index

end
