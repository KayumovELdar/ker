Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  concern :votable do
    member do
      post :vote_for
      post :vote_against
      delete :cancel_vote
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create]
      end
    end
  end

  root to: 'questions#index'

  resources :questions, concerns: %i[votable] do
    resources :answers, shallow: true, concerns: %i[votable] do
      patch :set_best, on: :member
      resources :comments, shallow: true, only: %i[create]
    end
    resources :comments, shallow: true, only: %i[create]
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

end
