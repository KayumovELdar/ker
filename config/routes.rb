Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :users, only: %i[] do
    get :badges, on: :member
  end

  resources :questions do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end
  resources :files, only: [:destroy]

  resources :links, only: [:destroy]
end
