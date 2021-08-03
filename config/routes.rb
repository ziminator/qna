Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: [:votable] do
      patch 'select_best', on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]

  mount ActionCable.server => '/cable'
end
