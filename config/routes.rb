require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
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

      resources :questions, only: %i[index show create destroy update] do
        resources :answers, only: %i[index show create destroy update], shallow: true
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
    resources :subscribes, shallow: true,
                           only: %i[create destroy]
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

end
